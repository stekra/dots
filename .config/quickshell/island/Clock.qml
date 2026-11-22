import QtQuick
import Quickshell
import qs

// Time (hours above minutes), with the date below in dimmer text.
// One CenteredText per line, so each line is centered by its visible digits.
Column {
    spacing: 6

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

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.alignWhenCentered: false
        CenteredText { id: hours; text: Qt.formatDateTime(clock.date, "HH") }
        CenteredText { text: Qt.formatDateTime(clock.date, "mm") }
    }

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.alignWhenCentered: false
        CenteredText { text: Qt.formatDateTime(clock.date, "ddd"); color: Theme.dim }
        CenteredText { text: Qt.formatDateTime(clock.date, "d"); color: Theme.dim }
        // one step smaller (the widest months, like "May", don't fit at full size),
        // and one step heavier so it looks as strong as the bigger lines above
        CenteredText { id: month; text: Qt.formatDateTime(clock.date, "MMM"); color: Theme.dim; font.pixelSize: Theme.fontSize - 2; font.weight: Font.DemiBold }
    }
}
