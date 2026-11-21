import QtQuick
import qs

// A small sun whose rays grow with `level` (0–1): short stubs when dim, long rays
// when bright. Plain shapes: a disc and 8 rounded rays around it.
Item {
    id: root
    property real level: 1
    property color color: Theme.fg

    readonly property real center: width / 2
    readonly property real core: 3.5     // disc radius
    readonly property real gap: 1.5      // between disc and rays
    property real ray: 0.8 + (center - core - gap - 0.8) * Math.max(0, Math.min(1, level))
    Behavior on ray { NumberAnimation { duration: 100 } }

    implicitWidth: 18
    implicitHeight: 18

    Rectangle {
        x: root.center - root.core
        y: root.center - root.core
        width: 2 * root.core
        height: width
        radius: width / 2
        color: root.color
    }

    Repeater {
        model: 8
        Rectangle {
            required property int index
            width: 1.6
            height: root.ray
            radius: width / 2
            // pointing up from the disc, then turned around the sun's center
            x: root.center - width / 2
            y: root.center - root.core - root.gap - height
            color: root.color
            transform: Rotation {
                origin.x: 0.8
                origin.y: root.core + root.gap + root.ray
                angle: index * 45
            }
        }
    }
}
