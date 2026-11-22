import QtQuick
import Quickshell
import qs

// Time (hours above minutes) and date, styled like Apple's status bar: the time in
// Semibold, the date in the secondary color with weekday and month as small
// uppercase labels. One CenteredText per line, so each line is centered by its
// visible characters.
Column {
    spacing: 7

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    // Text boxes have some empty space above the first digits and below the last
    // ones, and the two differ slightly. Pad the smaller side, so the visible gaps
    // above and below the clock come out equal.
    FontMetrics { id: metrics; font: hours.font }
    readonly property real inkTopInset: {
        metrics.font   // re-measure when the font changes
        return hours.baselineOffset + metrics.tightBoundingRect(hours.text).y
    }
    FontMetrics { id: monthMetrics; font: month.font }
    readonly property real inkBottomInset: {
        monthMetrics.font
        const ink = monthMetrics.tightBoundingRect(month.text)
        return month.height - (month.baselineOffset + ink.y + ink.height)
    }
    topPadding: Math.max(0, inkBottomInset - inkTopInset)
    bottomPadding: Math.max(0, inkTopInset - inkBottomInset)

    // small uppercase label (weekday, month), in Apple's narrower SF Compact so the
    // widest ones ("MON", "MAY") still have room in the pill; SF Pro if it's missing
    component Label: CenteredText {
        color: Theme.secondary
        font.family: Qt.fontFamilies().includes("SF Compact Text") ? "SF Compact Text" : Theme.font
        font.pixelSize: Theme.fontSize - 3.5
        font.weight: Font.DemiBold
    }

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.alignWhenCentered: false
        CenteredText { id: hours; text: Qt.formatDateTime(clock.date, "HH"); font.weight: Font.DemiBold }
        CenteredText { text: Qt.formatDateTime(clock.date, "mm"); font.weight: Font.DemiBold }
    }

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.alignWhenCentered: false
        Label { text: Qt.formatDateTime(clock.date, "ddd").toUpperCase() }
        CenteredText { text: Qt.formatDateTime(clock.date, "d"); color: Theme.secondary }
        Label { id: month; text: Qt.formatDateTime(clock.date, "MMM").toUpperCase() }
    }
}
