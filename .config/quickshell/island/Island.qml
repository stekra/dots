import QtQuick
import Quickshell
import qs
import qs.services

// The window is a fixed, transparent strip down the left edge of the screen.
// The content is placed so the clock sits exactly at the screen's vertical
// center and never moves; the pill is just the background, and it animates
// to fit behind whatever is showing (it grows upward when workspaces are added).
// Only the pill is clickable (mask).
PanelWindow {
    id: island
    required property ShellScreen modelData
    screen: modelData

    anchors { left: true; top: true; bottom: true }
    margins.left: Theme.gap
    implicitWidth: Theme.islandWidth
    // reserve Theme.edgeSpace from the screen edge (the zone counts from after
    // the margin), so the pill sits centered between the screen edge and windows
    exclusiveZone: Theme.edgeSpace - margins.left
    color: "transparent"
    mask: Region { item: pill }

    readonly property real padding: 12

    // background: follows the content exactly (so it keeps up with the dots'
    // own animation), and animates by itself only when switching to/from the OSD
    Rectangle {
        id: pill
        width: parent.width
        y: status.y - island.padding
        height: status.height + 2 * island.padding
        radius: width / 2
        color: Theme.bg

        states: State {
            name: "osd"
            when: Osd.shown
            PropertyChanges {
                target: pill
                y: osd.y - island.padding
                height: osd.height + 2 * island.padding
            }
        }
        transitions: Transition {
            NumberAnimation { properties: "y,height"; duration: 250; easing.type: Easing.OutCubic }
        }
    }

    // normal content, with the middle of the clock at the screen's center
    // (full pill width, and no rounding to whole pixels, so every element is
    // centered on the pill's exact middle)
    Column {
        id: status
        width: parent.width
        y: island.height / 2 - (workspaces.height + spacing + clock.height / 2)
        spacing: 16
        opacity: Osd.shown ? 0 : 1
        Behavior on opacity { NumberAnimation { duration: 100 } }

        Workspaces {
            id: workspaces; screen: island.screen
            anchors.horizontalCenter: parent.horizontalCenter; anchors.alignWhenCentered: false
        }
        Clock {
            id: clock
            anchors.horizontalCenter: parent.horizontalCenter; anchors.alignWhenCentered: false
        }
        // status group: network, bluetooth, battery
        Column {
            anchors.horizontalCenter: parent.horizontalCenter; anchors.alignWhenCentered: false
            spacing: 10

            NetworkIcon { anchors.horizontalCenter: parent.horizontalCenter; anchors.alignWhenCentered: false }
            BluetoothIcon { anchors.horizontalCenter: parent.horizontalCenter; anchors.alignWhenCentered: false }
            Battery { anchors.horizontalCenter: parent.horizontalCenter; anchors.alignWhenCentered: false }
        }
    }

    // volume / brightness level, shown briefly after a change, centered on the same spot
    OsdLevel {
        id: osd
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.alignWhenCentered: false
        y: island.height / 2 - height / 2
        opacity: Osd.shown ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 100 } }
    }
}
