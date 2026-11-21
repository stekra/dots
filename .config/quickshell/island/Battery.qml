import QtQuick
import Quickshell.Services.UPower
import qs

// macOS 26-style battery, standing upright: flat shapes, no outline. The empty
// part is a faint version of the text color; the charge fills from the bottom.
Item {
    id: root
    readonly property var battery: UPower.displayDevice
    readonly property bool charging: battery.state === UPowerDeviceState.Charging
    readonly property bool low: battery.percentage <= 0.2 && !charging

    readonly property color emptyColor: Theme.dim
    readonly property color fillColor: charging ? Theme.good : low ? Theme.warning : Theme.fg

    // the size is just the body: the small, faint nub sits above it, outside the
    // layout, so spacing to the battery is measured to the body (what the eye sees)
    implicitWidth: body.width
    implicitHeight: body.height

    Rectangle {
        id: nub
        x: (body.width - width) / 2   // exact center (anchors would round to a whole pixel)
        y: -(height + 1)
        width: 4
        height: 1.5
        radius: 1
        color: root.emptyColor
    }

    Rectangle {
        id: body
        width: 11
        height: 18
        radius: 4
        color: root.emptyColor

        // the charge: a full copy of the body, cropped from the top, so its
        // bottom always follows the body's rounded corners exactly
        Item {
            anchors.bottom: parent.bottom
            width: body.width
            height: body.height * root.battery.percentage
            clip: true

            Rectangle {
                anchors.bottom: parent.bottom
                width: body.width
                height: body.height
                radius: body.radius
                color: root.fillColor
            }
        }
    }
}
