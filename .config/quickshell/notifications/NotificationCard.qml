import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import qs
import qs.services

// One popup. Grows out of the clock's center (the middle of the island) when it
// arrives, and shrinks back into it when it leaves (timeout, click, or the app
// closing it). Hovering pauses the timeout.
//   left click:  run the app's default action (usually: open it) and dismiss
//   right click: dismiss
Item {
    id: slot
    required property int index
    required property int nid

    readonly property Notification notification: Notifications.get(nid)
    readonly property int gap: 6
    readonly property int padding: 12
    readonly property int duration: 250

    // while leaving, the notification may already be gone, so show a copy
    property var copy: null
    readonly property string summary: copy ? copy.summary : (notification?.summary ?? "")
    readonly property string body: copy ? copy.body : (notification?.body ?? "")
    readonly property string icon: copy ? copy.icon : iconFor(notification)
    readonly property var actions: copy ? [] : (notification?.actions ?? []).filter(a => a.identifier !== "default")

    // ms until it goes away by itself; 0 = stays (critical, or the app asked for it)
    readonly property int timeout: {
        if (!notification) return 0
        if (notification.urgency === NotificationUrgency.Critical) return 0
        if (notification.expireTimeout > 0) return notification.expireTimeout   // already ms
        if (notification.expireTimeout === 0) return 0
        return Notifications.defaultTimeout
    }

    function iconFor(n) {
        if (!n) return ""
        if (n.image) return n.image
        const name = n.appIcon || (DesktopEntries.byId(n.desktopEntry)?.icon ?? "")
        if (!name) return ""
        if (name.startsWith("/") || name.startsWith("file:") || name.startsWith("image:")) return name
        return Quickshell.iconPath(name, true)
    }

    // how: "expire" (timed out), "dismiss" (closed by the user), or "" (already closed)
    function leave(how) {
        if (copy) return
        copy = { summary: summary, body: body, icon: icon }
        if (notification) {
            if (how === "expire") notification.expire()
            else if (how === "dismiss") notification.dismiss()
        }
        appearAnimation.stop()
        leaveAnimation.start()
    }

    // 0 → 1 when it arrives, 1 → 0 when it leaves
    property real appear: 0
    width: card.width
    height: (card.height + gap) * appear

    Component.onCompleted: appearAnimation.start()
    NumberAnimation {
        id: appearAnimation
        target: slot; property: "appear"; to: 1
        duration: slot.duration; easing.type: Easing.OutCubic
    }
    SequentialAnimation {
        id: leaveAnimation
        NumberAnimation { target: slot; property: "appear"; to: 0; duration: slot.duration; easing.type: Easing.OutCubic }
        ScriptAction { script: Notifications.remove(slot.nid) }
    }

    // the app closed it, or it was replaced away
    Connections {
        target: slot.notification
        function onClosed() { slot.leave("") }
    }

    // only the newest few stay on screen
    readonly property bool overflow: index >= Notifications.maxPopups
    onOverflowChanged: if (overflow) leave("expire")

    Timer {
        interval: slot.timeout
        running: slot.timeout > 0 && !slot.copy && !hover.hovered && slot.appear === 1
        onTriggered: slot.leave("expire")
    }

    Item {
        id: card
        // grows from the clock's center: the window's left edge is the island's
        // center line, and the window's vertical middle is the clock's center
        opacity: slot.appear
        transform: Scale {
            origin.x: slot.parent ? -slot.parent.x : 0
            origin.y: slot.parent ? slot.parent.parent.height / 2 - slot.parent.y - slot.y : 0
            xScale: slot.appear
            yScale: slot.appear
        }
        width: Theme.notificationWidth
        height: content.height + 2 * slot.padding

        SmoothRect {
            anchors.fill: parent
            radius: Theme.islandWidth / 2
            color: Theme.bg
        }

        HoverHandler { id: hover }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            cursorShape: Qt.PointingHandCursor
            onClicked: mouse => {
                if (mouse.button === Qt.LeftButton) {
                    const action = (slot.notification?.actions ?? []).find(a => a.identifier === "default")
                    if (action) action.invoke()
                }
                slot.leave("dismiss")
            }
        }

        Row {
            id: content
            x: slot.padding
            y: slot.padding
            spacing: 10

            Image {
                visible: slot.icon !== ""
                width: 32
                height: 32
                source: slot.icon
                sourceSize: Qt.size(64, 64)
                fillMode: Image.PreserveAspectFit
                // not asynchronous: loading theme icons off the main thread crashes quickshell
            }

            Column {
                width: card.width - 2 * slot.padding - (slot.icon !== "" ? 32 + content.spacing : 0)
                spacing: 2

                Text {
                    width: parent.width
                    text: slot.summary
                    elide: Text.ElideRight
                    color: Theme.fg
                    font.family: Theme.font
                    font.pixelSize: Theme.fontSize
                    font.weight: Font.DemiBold
                }
                Text {
                    width: parent.width
                    text: slot.body
                    visible: text !== ""
                    textFormat: Text.PlainText
                    wrapMode: Text.Wrap
                    maximumLineCount: 3
                    elide: Text.ElideRight
                    color: Qt.alpha(Theme.fg, 0.7)
                    font.family: Theme.font
                    font.pixelSize: Theme.fontSize
                }

                // buttons for the app's actions (besides the default one)
                Row {
                    visible: slot.actions.length > 0
                    topPadding: 6
                    spacing: 6

                    Repeater {
                        model: slot.actions
                        Rectangle {
                            required property var modelData
                            width: label.width + 20
                            height: label.height + 8
                            radius: height / 2
                            color: Theme.dim

                            Text {
                                id: label
                                anchors.centerIn: parent
                                text: parent.modelData.text
                                color: Theme.fg
                                font.family: Theme.font
                                font.pixelSize: Theme.fontSize - 1
                                font.weight: Font.Medium
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    parent.modelData.invoke()
                                    slot.leave("dismiss")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
