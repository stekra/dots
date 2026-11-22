pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs

// Screen brightness, read from sysfs. Watching the file catches every change
// (keys, brightnessctl, anything else), so nothing needs to notify the shell.
// Brightness keys call `qs ipc call brightness up|down`, which moves one step and
// snaps to the step grid (Theme.levelSteps), so the level always lands on a notch.
Singleton {
    id: root

    // the backlight device, found at startup (e.g. "intel_backlight", "amdgpu_bl0");
    // empty when there is none (desktops), and then the keys do nothing
    property string deviceName: ""
    readonly property string device: deviceName ? "/sys/class/backlight/" + deviceName : ""

    property bool ready: false
    property int current: 0
    property int max: 0
    // the bottom step: on this panel everything up to raw 12 looks the same as the
    // dimmest it can do (calibrated by eye), so starting here keeps every step visible
    readonly property int minimum: 12

    // Brightness on a perceptual scale (like `brightnessctl -e4`: raw ∝ scale⁴), so
    // each step looks equally big. The scale runs from the dimmest the hardware can
    // do (`minimum`) to full, so the steps split the *visible* range evenly: the
    // bottom step is the minimum, and no two steps end up (almost) the same.
    readonly property real minScale: max > 0 ? Math.pow(minimum / max, 1 / 4) : 0

    // level (0–1, for the bar and the keys) → raw value
    function rawFor(level) {
        return Math.round(max * Math.pow(minScale + (1 - minScale) * level, 4))
    }

    // raw value → level (0–1)
    readonly property real level: {
        if (max <= 0) return 0
        const scale = Math.pow(current / max, 1 / 4)
        return Math.max(0, Math.min(1, (scale - minScale) / (1 - minScale)))
    }

    // the file updates a moment after brightness is set, so fast key repeats
    // continue from the last step we set rather than the not-yet-updated value
    property int lastStep: 0
    property real lastStepTime: 0

    function step(direction) {
        if (!ready) return
        const steps = Theme.levelSteps
        const from = Date.now() - lastStepTime < 400 ? lastStep : Math.round(level * steps)
        lastStep = Math.max(0, Math.min(steps, from + direction))
        lastStepTime = Date.now()
        set(rawFor(lastStep / steps))
    }

    // Writing the brightness file directly takes ~1 ms; starting brightnessctl for
    // every step takes ~75 ms and makes held keys crawl. Direct writes need write
    // access to the file (here: a udev rule giving the wheel group access); where
    // that's missing, the first failed write switches to brightnessctl for good.
    property bool directWrites: true
    property int pending: -1

    function set(raw) {
        if (directWrites) {
            pending = raw
            writer.setText(String(raw))
        } else {
            Quickshell.execDetached(["brightnessctl", "-d", deviceName, "-q", "set", String(raw)])
        }
    }

    FileView {
        id: writer
        path: root.device ? root.device + "/brightness" : ""
        atomicWrites: false   // sysfs files can't be replaced, only written to
        onSaveFailed: {
            console.log("Brightness: can't write " + path + ", using brightnessctl from now on")
            root.directWrites = false
            if (root.pending >= 0) root.set(root.pending)
        }
    }

    IpcHandler {
        target: "brightness"
        function up(): void { root.step(1) }
        function down(): void { root.step(-1) }
    }

    // find the backlight device; with several, prefer the kernel's recommended
    // order: firmware, then platform, then raw
    Process {
        running: true
        command: ["sh", "-c", "for d in /sys/class/backlight/*; do [ -e \"$d/type\" ] && echo \"$(cat \"$d/type\") ${d##*/}\"; done"]
        stdout: StdioCollector {
            onStreamFinished: {
                const rank = { firmware: 0, platform: 1, raw: 2 }
                const found = text.trim().split("\n").filter(l => l).map(l => l.split(" "))
                found.sort((a, b) => (rank[a[0]] ?? 3) - (rank[b[0]] ?? 3))
                root.deviceName = found.length ? found[0][1] : ""
            }
        }
    }

    // `ready` turns on once both files have loaded, so startup doesn't count as a change
    FileView {
        path: root.device ? root.device + "/max_brightness" : ""
        onLoaded: {
            root.max = parseInt(text())
            if (root.current > 0) root.ready = true
        }
    }

    FileView {
        path: root.device ? root.device + "/brightness" : ""
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            root.current = parseInt(text())
            if (root.max > 0) root.ready = true
        }
    }
}
