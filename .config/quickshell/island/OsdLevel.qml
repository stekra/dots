import QtQuick
import qs
import qs.services

// Vertical level bar (fills upward) with the icon below it, for volume or brightness.
Column {
    id: root
    spacing: 10

    readonly property bool isVolume: Osd.kind === "volume"
    readonly property real value: isVolume ? (Audio.muted ? 0 : Audio.volume) : Brightness.level

    // the speaker follows the volume: crossed out when muted, no sound waves at 0,
    // one wave up to half, two waves above
    readonly property string volumeIcon: {
        if (Audio.muted) return String.fromCodePoint(0xF0581)
        if (value <= 0) return String.fromCodePoint(0xF057F)
        return String.fromCodePoint(value <= 0.5 ? 0xF0580 : 0xF057E)
    }

    Rectangle {
        id: track
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.alignWhenCentered: false
        implicitWidth: 6
        implicitHeight: 100
        radius: width / 2
        color: Theme.dim

        // the fill: a full copy of the bar, cropped from the top, so its top edge
        // is flat like the step cuts (and only rounded once it's completely full)
        Item {
            anchors.bottom: parent.bottom
            width: parent.width
            height: parent.height * Math.min(root.value, 1)
            clip: true
            Behavior on height { NumberAnimation { duration: 100 } }

            Rectangle {
                anchors.bottom: parent.bottom
                width: track.width
                height: track.height
                radius: track.radius
                color: Theme.fg
            }
        }

        // thin cuts between the steps (one segment per key press), drawn over the fill
        Repeater {
            model: Theme.levelSteps - 1
            Rectangle {
                required property int index
                width: parent.width
                height: 1
                y: parent.height * (index + 1) / Theme.levelSteps - height / 2
                color: Theme.bg
            }
        }
    }

    // the icon; same height for both kinds, so the OSD doesn't change size
    Item {
        width: Math.max(speaker.width, sun.width)
        height: Math.max(speaker.height, sun.height)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.alignWhenCentered: false

        // centered by its visible glyph, so it lines up with the bar
        CenteredText {
            id: speaker
            visible: root.isVolume
            anchors.verticalCenter: parent.verticalCenter
            text: root.volumeIcon
            lineHeight: 1
            font.family: Theme.iconFont
            font.pixelSize: 17
            font.weight: Font.Normal
        }

        SunIcon {
            id: sun
            visible: !root.isVolume
            anchors.centerIn: parent
            anchors.alignWhenCentered: false
            level: Brightness.level
        }
    }
}
