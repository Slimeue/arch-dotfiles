import QtQuick
import QtQuick.Layouts
import qs.components
import qs.config
import qs.services
import qs.utils

// The clock, stacked vertically.
//
// A 40px-wide bar cannot fit "14:32", so the time is split across lines: hour
// above minute, with the day above both. The negative top margins pull the
// digits together into one block -- the layout's own spacing is right for the
// gap between sections but far too loose between two lines of the same number.
StyledRect {
    id: root

    readonly property color colour: Colours.tertiary

    implicitWidth: Config.bar.innerWidth
    implicitHeight: layout.implicitHeight + Appearance.padding.medium * 2

    color: Colours.surfaceContainer
    radius: Appearance.rounding.full

    ColumnLayout {
        id: layout

        anchors.centerIn: parent
        spacing: Appearance.spacing.extraSmall

        Icon {
            Layout.alignment: Qt.AlignHCenter

            visible: Config.bar.clock.showIcon
            text: Icons.calendar
            size: Appearance.font.size.normal
            color: root.colour
        }

        // Day name and number, with a hairline rule under them separating the
        // date from the time.
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter

            visible: Config.bar.clock.showDate
            spacing: 0

            StyledText {
                Layout.alignment: Qt.AlignHCenter

                text: Time.dayName
                font.pixelSize: Appearance.font.size.small
                color: root.colour
            }

            StyledText {
                Layout.alignment: Qt.AlignHCenter

                text: Time.dayNum
                font.pixelSize: Appearance.font.size.larger
                font.bold: true
                color: root.colour
            }

            StyledRect {
                Layout.fillWidth: true
                Layout.topMargin: Appearance.spacing.extraSmall / 2
                Layout.bottomMargin: Appearance.spacing.extraSmall / 2

                implicitHeight: 1
                color: Colours.outlineVar
            }
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter

            text: Time.hourStr
            font.pixelSize: Appearance.font.size.larger
            font.bold: true
            color: root.colour
        }

        StyledText {
            // Pulled up against the hour so the two lines read as one time
            // rather than two separate numbers.
            Layout.topMargin: -layout.spacing
            Layout.alignment: Qt.AlignHCenter

            text: Time.minuteStr
            font.pixelSize: Appearance.font.size.larger
            color: root.colour
        }

        StyledText {
            Layout.topMargin: -layout.spacing
            Layout.alignment: Qt.AlignHCenter

            visible: Config.bar.clock.showSeconds
            text: Time.secondStr
            font.pixelSize: Appearance.font.size.small
            color: root.colour
        }

        StyledText {
            Layout.topMargin: -layout.spacing
            Layout.alignment: Qt.AlignHCenter

            visible: Config.bar.clock.twelveHour
            text: Time.amPmStr
            font.pixelSize: Appearance.font.size.small
            color: root.colour
        }
    }
}
