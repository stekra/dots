import QtQuick
import qs

// One line of text, centered by its visible glyphs rather than its box
// (digits like "1" or "20" sit slightly off-center in their box otherwise).
Text {
    id: root

    FontMetrics { id: metrics; font: root.font }
    // how far the glyphs' middle is from the box's middle (measured against the
    // box itself: icon glyphs can be wider than the space the font reserves)
    readonly property real inkOffset: {
        metrics.font   // re-measure when the font changes (the GTK font loads after startup)
        const ink = metrics.tightBoundingRect(text)
        return ink.x + ink.width / 2 - width / 2
    }

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.horizontalCenterOffset: -inkOffset
    anchors.alignWhenCentered: false

    lineHeight: 0.9
    color: Theme.fg
    font.family: Theme.font
    font.pixelSize: Theme.fontSize
    font.weight: Font.Medium
}
