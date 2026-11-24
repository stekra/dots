import QtQuick
import QtQuick.Shapes
import Quickshell.Services.UPower
import qs

// Apple-style battery, lying down: flat shapes, no outline. The body is twice as
// wide as it is tall, with Apple's continuous corners; the empty part is the faint
// Theme.dim and the charge fills from the left. The nub sits to the right with a
// small gap, rounded only on its outer side. Low: red. Charging: green, with a
// lightning bolt. 16 wide, about as wide as the wifi icon above it.
// Hidden on machines without a laptop battery (desktops); the island closes the gap.
Item {
    id: root
    readonly property var battery: UPower.displayDevice
    visible: battery.isLaptopBattery
    readonly property bool charging: battery.state === UPowerDeviceState.Charging
    readonly property bool low: battery.percentage <= 0.2 && !charging

    readonly property color fillColor: charging ? Theme.good : low ? Theme.critical : Theme.fg

    // body and nub together, so the whole shape is what gets centered
    implicitWidth: nub.x + nub.width
    implicitHeight: body.height

    Item {
        id: body
        width: 16
        height: 8
        readonly property real radius: 2.6

        SmoothRect {
            anchors.fill: parent
            radius: body.radius
            color: Theme.dim
        }

        // the charge: a full copy of the body, cropped from the right, so its
        // left side always follows the body's rounded corners exactly
        Item {
            width: body.width * root.battery.percentage
            height: body.height
            clip: true
            Behavior on width { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }

            SmoothRect {
                width: body.width
                height: body.height
                radius: body.radius
                color: root.fillColor
                Behavior on color { ColorAnimation { duration: 250 } }
            }
        }

        // lightning bolt while charging, in the background color (fades in and out)
        Shape {
            opacity: root.charging ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 250 } }
            anchors.centerIn: parent
            anchors.alignWhenCentered: false
            width: 4
            height: 6.5
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                fillColor: Theme.bg
                strokeColor: Theme.bg
                strokeWidth: 0.5
                joinStyle: ShapePath.RoundJoin
                scale: Qt.size(4, 6.5)   // the points below are 0–1
                PathPolyline {
                    path: [Qt.point(0.62, 0), Qt.point(0.06, 0.58), Qt.point(0.46, 0.58), Qt.point(0.36, 1),
                           Qt.point(0.94, 0.40), Qt.point(0.54, 0.40), Qt.point(0.62, 0)]
                }
            }
        }
    }

    Rectangle {
        id: nub
        x: body.width + 1
        y: (body.height - height) / 2
        width: 1.2
        height: 3
        topRightRadius: width
        bottomRightRadius: width
        color: Theme.dim
    }
}
