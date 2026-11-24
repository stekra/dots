import QtQuick
import QtQuick.Shapes
import qs

// A rectangle with Apple's "continuous" corners (iOS/macOS, SwiftUI's
// RoundedRectangle(style: .continuous)): instead of a circular arc, each corner is
// three Bézier curves that ease in from the straight edge, so there's no visible
// "kink" where the curve starts. `radius` means the same as Apple's corner radius;
// the curve starts 1.528 × radius from the corner.
Shape {
    id: root
    property real radius: 0
    property color color: Theme.fg

    preferredRendererType: Shape.CurveRenderer

    // the outline as an SVG path, clockwise from the top edge
    readonly property string outline: {
        const w = width, h = height
        // the curve needs 1.528 × radius along each edge; smaller shapes get a smaller radius
        const r = Math.max(0, Math.min(radius, Math.min(w, h) / 2 / 1.52866483))
        // Apple's corner, as offsets from the corner point: [along the edge, into the shape]
        const k = [[1.52866483, 0], [1.08849296, 0], [0.86840694, 0], [0.63149379, 0.07491139],
                   [0.37282383, 0.16905956], [0.16905956, 0.37282383], [0.07491139, 0.63149379],
                   [0, 0.86840694], [0, 1.08849296], [0, 1.52866483]]
        // each corner: its position, and the directions "back along the edge" and "into the shape"
        const corners = [[w, 0, -1, 0, 0, 1], [w, h, 0, -1, -1, 0], [0, h, 1, 0, 0, -1], [0, 0, 0, 1, 1, 0]]
        const pt = (c, i) => {
            const [x, y, ax, ay, bx, by] = c
            const a = k[i][0] * r, b = k[i][1] * r
            return (x + ax * a + bx * b).toFixed(3) + " " + (y + ay * a + by * b).toFixed(3)
        }
        let d = "M " + pt(corners[0], 0)
        for (const c of corners) {
            d += " L " + pt(c, 0)
            for (let i = 1; i < 10; i += 3)
                d += " C " + pt(c, i) + " " + pt(c, i + 1) + " " + pt(c, i + 2)
        }
        return d + " Z"
    }

    ShapePath {
        strokeWidth: -1
        fillColor: root.color
        PathSvg { path: root.outline }
    }
}
