pragma Singleton
import QtQuick
import Quickshell

// Decides when the island shows the volume/brightness level: on any change,
// for a moment, then it goes back to normal.
Singleton {
    property bool shown: false
    property string kind: "volume"   // "volume" or "brightness"

    function show(newKind) {
        kind = newKind
        shown = true
        hideTimer.restart()
    }

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: shown = false
    }

    Connections {
        target: Audio
        function onVolumeChanged() { if (Audio.ready) show("volume") }
        function onMutedChanged() { if (Audio.ready) show("volume") }
    }

    Connections {
        target: Brightness
        function onLevelChanged() { if (Brightness.ready) show("brightness") }
    }
}
