import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Bluetooth
import qs

// Bluetooth status, straight from BlueZ: bright while a device is connected, dim
// otherwise (off, or on with nothing connected). Click: opens bluetui.
// Drawn like Apple's Bluetooth symbol: the rune as one line of even thickness,
// with round ends and rounded corners.
Item {
    id: root

    readonly property bool connected: Bluetooth.devices.values.some(d => d.connected)

    implicitWidth: 9
    implicitHeight: 13

    Shape {
        id: rune
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        readonly property real line: 1.6
        readonly property real yTop: line / 2
        readonly property real yBottom: height - line / 2
        readonly property real cx: width / 2
        readonly property real arm: (width - line) / 2          // how far the corners reach sideways
        readonly property real upper: yTop + 0.27 * (yBottom - yTop)     // height of the two corners
        readonly property real lower: yTop + 0.73 * (yBottom - yTop)

        ShapePath {
            fillColor: "transparent"
            // when dim: Theme.dim blended onto the island's background, as a solid
            // color, so the places where the line crosses itself don't turn darker
            strokeColor: root.connected ? Theme.fg : Qt.tint(Theme.bg, Theme.dim)
            strokeWidth: rune.line
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            // upper-left end → lower-right corner → bottom → top → upper-right corner → lower-left end
            PathPolyline {
                path: [
                    Qt.point(rune.cx - rune.arm, rune.upper),
                    Qt.point(rune.cx + rune.arm, rune.lower),
                    Qt.point(rune.cx, rune.yBottom),
                    Qt.point(rune.cx, rune.yTop),
                    Qt.point(rune.cx + rune.arm, rune.upper),
                    Qt.point(rune.cx - rune.arm, rune.lower)
                ]
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        anchors.margins: -4
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(Theme.terminal.concat(["bluetui"]))
    }
}
