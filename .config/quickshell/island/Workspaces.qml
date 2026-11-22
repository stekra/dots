import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs

// Dots for this monitor's workspaces, top to bottom; the active one is a taller pill.
// New dots grow in, removed dots shrink away, and switching workspaces stretches
// and recolors the dots smoothly.
//
// The dots come from our own list of workspace ids (`slots`) rather than straight
// from Hyprland: an id stays in it until its dot has finished animating out, so a
// removed workspace can still shrink away smoothly.
Column {
    id: root
    required property ShellScreen screen
    readonly property int gap: 6
    readonly property int duration: 200

    // each dot carries its own gap below it (so it can grow in and out smoothly);
    // this removes the extra gap after the last one
    bottomPadding: -gap

    ListModel { id: slots }   // { wsId }, sorted by id

    // add a slot for every new workspace, keeping them sorted
    function addNew() {
        for (const ws of Hyprland.workspaces.values) {
            let i = 0
            while (i < slots.count && slots.get(i).wsId < ws.id) i++
            if (i === slots.count || slots.get(i).wsId !== ws.id)
                slots.insert(i, { wsId: ws.id })
        }
    }
    Component.onCompleted: addNew()
    Connections {
        target: Hyprland.workspaces
        function onValuesChanged() { root.addNew() }
    }

    Repeater {
        model: slots

        Item {
            id: slot
            required property int index
            required property int wsId

            // the live workspace, or null once Hyprland has removed it
            readonly property HyprlandWorkspace ws: Hyprland.workspaces.values.find(w => w.id === wsId) ?? null
            readonly property bool leaving: ws === null
            readonly property bool active: ws?.active ?? false

            // hide special workspaces (negative ids) and other monitors' workspaces
            visible: leaving || (wsId > 0 && ws.monitor?.name === root.screen.name)

            // 0 → 1 when the dot is added, 1 → 0 when it's removed
            property real appear: 0

            implicitWidth: dot.width
            implicitHeight: (dot.height + root.gap) * appear

            Component.onCompleted: addAnimation.start()
            onLeavingChanged: {
                if (leaving) {
                    addAnimation.stop()
                    removeAnimation.start()
                } else {   // the same workspace came back while animating out
                    removeAnimation.stop()
                    addAnimation.start()
                }
            }

            NumberAnimation {
                id: addAnimation
                target: slot; property: "appear"; to: 1
                duration: root.duration; easing.type: Easing.OutCubic
            }
            SequentialAnimation {
                id: removeAnimation
                NumberAnimation { target: slot; property: "appear"; to: 0; duration: root.duration; easing.type: Easing.OutCubic }
                ScriptAction { script: slots.remove(slot.index) }
            }

            Rectangle {
                id: dot
                anchors.horizontalCenter: parent.horizontalCenter
                width: 8
                height: slot.active ? 16 : 8
                radius: 4
                opacity: slot.appear
                color: slot.active ? Theme.fg : Theme.dim

                Behavior on height { NumberAnimation { duration: root.duration; easing.type: Easing.OutCubic } }
                Behavior on color { ColorAnimation { duration: root.duration } }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -4   // bigger click target than the dot
                    cursorShape: Qt.PointingHandCursor
                    onClicked: slot.ws?.activate()
                }
            }
        }
    }
}
