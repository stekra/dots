pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Shared look and sizes. Colors come from theme.json (written by
// ~/.config/themes/toggle.sh) and update live when the file changes.
Singleton {
    // colors
    readonly property color bg: json.bg
    readonly property color fg: json.fg
    // secondary elements (date, empty part of bars, inactive dots): the text
    // color, see-through, so it reads the same in light and dark
    readonly property color dim: Qt.alpha(fg, 0.3)
    // status colors, same in light and dark (macOS system orange/green)
    readonly property color warning: "#ff9f0a"
    readonly property color good: "#30d158"

    // fonts: GTK's interface font (family only), read once at startup
    property string font: ""
    readonly property int fontSize: 12
    readonly property string iconFont: "IoskeleyMonoTerm Nerd Font"

    // island and spacing
    readonly property int islandWidth: 24
    // between the island and the screen edge, and between the island and windows
    readonly property int gap: 4
    // how far windows stay from the left edge: gap + island + gap, minus 1 because
    // Hyprland's gaps_in already adds a pixel before the first window. The right
    // edge reserves the same, so windows sit centered on the screen.
    readonly property int edgeSpace: gap + islandWidth + gap - 1

    // notification cards
    readonly property int notificationWidth: 260
    readonly property int notificationGap: 8   // between the island and the cards

    // volume/brightness keys move in this many steps; the OSD bar shows the
    // same steps (12: half, quarters and thirds all land on a step)
    readonly property int levelSteps: 12

    // "SF Pro Text 11" -> "SF Pro Text"
    Process {
        running: true
        command: ["gsettings", "get", "org.gnome.desktop.interface", "font-name"]
        stdout: StdioCollector {
            onStreamFinished: font = text.trim().replace(/^'|'$/g, "").replace(/\s+[\d.]+$/, "")
        }
    }

    FileView {
        path: Quickshell.shellDir + "/theme.json"
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: json
            property string bg: "#222222"
            property string fg: "#ffffff"
        }
    }
}
