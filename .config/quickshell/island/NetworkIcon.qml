import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Networking
import qs

// Network status, straight from NetworkManager. Wifi: a fan (dot + three arcs)
// that lights up with signal strength, dim when not connected, orange when
// connected but without internet. Ethernet: a plug instead. Click: opens wlctl.
Item {
    id: root

    readonly property var devices: Networking.devices.values
    readonly property bool ethernet: devices.some(d => d.type === DeviceType.Wired && d.connected)
    readonly property var wifi: devices.find(d => d.type === DeviceType.Wifi) ?? null
    readonly property var network: wifi?.networks.values.find(n => n.connected) ?? null
    // NetworkManager's own internet check ("Unknown" when it can't tell: assume fine)
    readonly property bool online: Networking.connectivity === NetworkConnectivity.Full
                                   || Networking.connectivity === NetworkConnectivity.Unknown

    // how many parts of the fan are lit: 0 (not connected) to 4
    readonly property int bars: network ? 1 + Math.min(3, Math.floor(network.signalStrength * 4)) : 0
    readonly property color litColor: online ? Theme.fg : Theme.warning

    implicitWidth: 16
    implicitHeight: fan.outer

    // The fan, like Apple's wifi symbol: one 90° slice (point at the bottom
    // middle), cut into a dot and three bands. Every part ends exactly on the
    // slice's two straight edges, so together they form one clean "pizza slice"
    // outline. Corners are rounded slightly (the dot's point a bit more).
    Shape {
        id: fan
        visible: !root.ethernet
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        readonly property real dot: 3.2      // radius of the dot
        readonly property real band: 1.7     // thickness of each band
        readonly property real gap: 1.0      // between the parts
        readonly property real corner: 0.5   // corner rounding
        readonly property real tip: 1.0      // rounding of the dot's point
        readonly property real outer: dot + 3 * (gap + band)

        readonly property real cx: width / 2
        readonly property real cy: height
        readonly property real edgeL: -135    // the slice's edges, in degrees (0 = right, -90 = up)
        readonly property real edgeR: -45

        // inner and outer radius of part 0 (the dot) … 3 (the outer band)
        function innerOf(i) { return i === 0 ? 0 : dot + gap + (i - 1) * (band + gap) }
        function outerOf(i) { return i === 0 ? dot : innerOf(i) + band }

        // a point at distance r from the slice's point, in direction `degrees`
        function p(r, degrees) {
            const a = degrees * Math.PI / 180
            return (cx + r * Math.cos(a)).toFixed(3) + " " + (cy + r * Math.sin(a)).toFixed(3)
        }

        // One part as an SVG path: arcs along the circles, straight ends along the
        // slice's edges, and each corner replaced by a small curve.
        function part(i) {
            const c = corner
            const ro = outerOf(i), ri = innerOf(i)
            const so = c / ro * 180 / Math.PI   // `corner` as an angle on the outer arc
            let d = "M " + p(ro, edgeL + so)
                  + " A " + ro + " " + ro + " 0 0 1 " + p(ro, edgeR - so)
                  + " Q " + p(ro, edgeR) + " " + p(ro - c, edgeR)
            if (i === 0) {
                // down the right edge to the point, around it, up the left edge
                d += " L " + p(tip, edgeR) + " Q " + p(0, 0) + " " + p(tip, edgeL)
            } else {
                const si = c / ri * 180 / Math.PI
                d += " L " + p(ri + c, edgeR)
                   + " Q " + p(ri, edgeR) + " " + p(ri, edgeR - si)
                   + " A " + ri + " " + ri + " 0 0 0 " + p(ri, edgeL + si)
                   + " Q " + p(ri, edgeL) + " " + p(ri + c, edgeL)
            }
            return d + " L " + p(ro - c, edgeL) + " Q " + p(ro, edgeL) + " " + p(ro, edgeL + so) + " Z"
        }

        // a part is lit when the signal reaches it (and fades when that changes)
        function color(i) { return root.bars > i ? root.litColor : Theme.dim }

        ShapePath {
            strokeWidth: -1
            fillColor: fan.color(0)
            Behavior on fillColor { ColorAnimation { duration: 250 } }
            PathSvg { path: fan.part(0) }
        }
        ShapePath {
            strokeWidth: -1
            fillColor: fan.color(1)
            Behavior on fillColor { ColorAnimation { duration: 250 } }
            PathSvg { path: fan.part(1) }
        }
        ShapePath {
            strokeWidth: -1
            fillColor: fan.color(2)
            Behavior on fillColor { ColorAnimation { duration: 250 } }
            PathSvg { path: fan.part(2) }
        }
        ShapePath {
            strokeWidth: -1
            fillColor: fan.color(3)
            Behavior on fillColor { ColorAnimation { duration: 250 } }
            PathSvg { path: fan.part(3) }
        }
    }

    // ethernet plug
    CenteredText {
        visible: root.ethernet
        anchors.verticalCenter: parent.verticalCenter
        text: String.fromCodePoint(0xF0200)
        color: root.litColor
        lineHeight: 1
        font.family: Theme.iconFont
        font.pixelSize: 15
        font.weight: Font.Normal
    }

    MouseArea {
        anchors.fill: parent
        anchors.margins: -4
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(Theme.terminal.concat(["wlctl"]))
    }
}
