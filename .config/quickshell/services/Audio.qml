pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import qs

// Default output's volume and mute state, straight from Pipewire.
// Volume keys call `qs ipc call volume up|down`, which moves one step and snaps
// to the step grid (Theme.levelSteps), so the level always lands on a notch.
Singleton {
    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property bool ready: sink?.ready ?? false
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false

    // keeps the sink's volume/mute properties live
    PwObjectTracker { objects: [Pipewire.defaultAudioSink] }

    // Pipewire reports the new volume a moment after it's set, so fast key repeats
    // continue from the last step we set rather than the not-yet-updated value
    property int lastStep: 0
    property real lastStepTime: 0

    function step(direction) {
        if (!ready) return
        const steps = Theme.levelSteps
        const from = Date.now() - lastStepTime < 400 ? lastStep : Math.round(volume * steps)
        lastStep = Math.max(0, Math.min(steps, from + direction))
        lastStepTime = Date.now()
        sink.audio.volume = lastStep / steps
        if (direction > 0) sink.audio.muted = false
    }

    IpcHandler {
        target: "volume"
        function up(): void { step(1) }
        function down(): void { step(-1) }
    }
}
