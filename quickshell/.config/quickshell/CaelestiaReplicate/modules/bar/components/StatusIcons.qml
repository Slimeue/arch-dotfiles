import QtQuick
import QtQuick.Layouts
import qs.components
import qs.config
import qs.services
import qs.utils

// Network, volume and battery, in one rounded pill.
//
// Grouping them matters: three loose icons in a narrow bar read as clutter,
// while one pill reads as a status block. Each icon hides itself when it has
// nothing to say -- no battery on a desktop, no wifi glyph when a cable is in --
// and the pill shrinks to fit whatever is left.
StyledRect {
    id: root

    readonly property color colour: Colours.secondary

    implicitWidth: Config.bar.innerWidth
    implicitHeight: column.implicitHeight + Appearance.padding.medium * 2

    color: Colours.surfaceContainer
    radius: Appearance.rounding.full

    // Scrolling the pill changes volume, matching caelestia's bar gestures.
    WheelHandler {
        enabled: Config.scrollActions.volume
        onWheel: event => {
            if (event.angleDelta.y > 0)
                Audio.incrementVolume(0.05);
            else if (event.angleDelta.y < 0)
                Audio.decrementVolume(0.05);
        }
    }

    Behavior on implicitHeight {
        Anim {}
    }

    ColumnLayout {
        id: column

        anchors.centerIn: parent
        spacing: Appearance.spacing.small

        // Network. Wired shows a socket glyph and no strength, since a cable
        // has no signal to report.
        Icon {
            Layout.alignment: Qt.AlignHCenter

            text: Net.kind === "wired" ? Icons.ethernet : Net.kind === "wifi" ? Icons.wifi(Net.strength) : Icons.wifiOff
            size: Appearance.font.size.larger
            color: Net.connected ? root.colour : Colours.outline
        }

        Icon {
            Layout.alignment: Qt.AlignHCenter

            text: Icons.volume(Audio.percent, Audio.muted)
            size: Appearance.font.size.larger
            color: Audio.muted ? Colours.outline : root.colour

            TapHandler {
                onTapped: Audio.toggleMute()
            }
        }

        // Battery. Absent entirely on a desktop; turns error-coloured rather
        // than changing shape when it gets low, so a glance at colour is
        // enough.
        Icon {
            Layout.alignment: Qt.AlignHCenter

            visible: Battery.available
            text: Icons.battery(Battery.percent, Battery.charging)
            size: Appearance.font.size.larger
            color: Battery.low ? Colours.error : root.colour
        }
    }
}
