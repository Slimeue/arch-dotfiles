pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.components
import qs.config
import qs.services
import qs.utils

// Album art and a play/pause toggle.
//
// Caelestia's bar has no media widget -- it lives in their dashboard. This is
// the horizontal MediaControls from the previous bar, reduced to what fits in
// 40px: the art, and one button. Track text is dropped rather than rotated,
// because a scrolling vertical title next to a rotated window title is noise.
//
// Off by default; switch on the "media" entry in config/Config.qml to show it.
ColumnLayout {
    id: root

    // playerctld is a proxy that mirrors every other player on the bus, so
    // counting it would list the current track twice.
    readonly property var candidates: Mpris.players.values.filter(p => !p.dbusName.includes("playerctld"))

    // Prefer whatever is actually playing; fall back to the first paused player
    // so this still shows what you were last listening to.
    readonly property var player: root.candidates.find(p => p.isPlaying) ?? root.candidates[0] ?? null
    readonly property bool hasPlayer: root.player !== null

    visible: root.hasPlayer
    spacing: Appearance.spacing.extraSmall

    // Spotify serves art over https, so it arrives asynchronously and is simply
    // omitted until it does.
    ClippingRectangle {
        Layout.alignment: Qt.AlignHCenter

        visible: art.status === Image.Ready
        implicitWidth: Config.bar.media.artSize
        implicitHeight: Config.bar.media.artSize
        radius: Appearance.rounding.small
        color: "transparent"

        Image {
            id: art

            anchors.fill: parent

            source: root.hasPlayer ? root.player.trackArtUrl : ""
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            // Twice the drawn size, so it stays crisp on a scaled display.
            sourceSize.width: Config.bar.media.artSize * 2
            sourceSize.height: Config.bar.media.artSize * 2
        }

        TapHandler {
            enabled: root.hasPlayer && root.player.canRaise
            onTapped: root.player.raise()
        }
    }

    Icon {
        Layout.alignment: Qt.AlignHCenter

        text: root.hasPlayer && root.player.isPlaying ? Icons.mediaPause : Icons.mediaPlay
        size: Appearance.font.size.normal
        color: Colours.onSurfaceVar
        opacity: hover.hovered ? 1 : 0.75

        Behavior on opacity {
            Anim {
                duration: Appearance.anim.durations.expressiveFastEffects
            }
        }

        HoverHandler {
            id: hover
        }

        TapHandler {
            enabled: root.hasPlayer && root.player.canTogglePlaying
            onTapped: root.player.togglePlaying()
        }
    }
}
