import QtQuick
import Quickshell
import qs

// Invisible strip on the right edge that only reserves space (like a "strut" in
// niri): the same amount the island takes on the left, so windows are centered
// on the screen. It sits below windows and lets every click through.
PanelWindow {
    required property ShellScreen modelData
    screen: modelData

    anchors { right: true; top: true; bottom: true }
    implicitWidth: 1
    exclusiveZone: Theme.edgeSpace
    aboveWindows: false
    color: "transparent"
    mask: Region {}   // empty: takes no clicks
}
