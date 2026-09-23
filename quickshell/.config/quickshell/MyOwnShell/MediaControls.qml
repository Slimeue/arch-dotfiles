pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Mpris

// Transport controls for whatever is playing, over MPRIS rather than the
// tray. Spotify's tray icon only ever offered a menu; this gives the track
// and the buttons directly.
RowLayout {
    id: root

    // playerctld is a proxy that mirrors every other player on the bus, so
    // counting it would list the current track twice.
    readonly property var candidates: Mpris.players.values
        .filter(p => !p.dbusName.includes("playerctld"))

    // Prefer whatever is actually playing; fall back to the first paused
    // player so this still shows what you were last listening to.
    readonly property var player: candidates.find(p => p.isPlaying)
        ?? candidates[0]
        ?? null

    readonly property bool hasPlayer: root.player !== null

    spacing: Style.islandSpacing

    // Album art. Spotify serves this over https, so it loads asynchronously
    // and is simply omitted until it arrives.
    ClippingRectangle {
        visible: root.hasPlayer && art.status === Image.Ready
        implicitWidth: Style.mediaArtSize
        implicitHeight: Style.mediaArtSize
        radius: 3
        color: "transparent"

        Image {
            id: art
            anchors.fill: parent
            source: root.hasPlayer ? root.player.trackArtUrl : ""
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            sourceSize.width: Style.mediaArtSize * 2   // crisp on a scaled screen
            sourceSize.height: Style.mediaArtSize * 2
        }
    }

    Text {
        visible: root.hasPlayer
        text: root.hasPlayer
            ? (root.player.trackArtist
                ? root.player.trackArtist + "  ·  " + root.player.trackTitle
                : root.player.trackTitle)
            : ""
        color: Style.fg
        font.family: Style.fontFamily
        font.pixelSize: Style.fontSize
        elide: Text.ElideRight
        Layout.maximumWidth: Style.mediaMaxWidth

        // Clicking the track raises the player's window.
        TapHandler {
            enabled: root.hasPlayer && root.player.canRaise
            onTapped: root.player.raise()
        }
    }

    // Transport. Each button dims when the player says it cannot do the
    // thing, rather than disappearing and reflowing the row.
    Repeater {
        model: [
            { glyph: "", action: "previous", capability: "canGoPrevious" },
            { glyph: "",       action: "toggle",   capability: "canTogglePlaying" },
            { glyph: "", action: "next",     capability: "canGoNext" }
        ]

        Text {
            id: button
            required property var modelData

            visible: root.hasPlayer
            // The middle entry has no fixed glyph -- it tracks play state.
            text: button.modelData.glyph !== ""
                ? button.modelData.glyph
                : (root.hasPlayer && root.player.isPlaying ? "" : "")
            color: Style.fg
            font.family: Style.fontFamily
            font.pixelSize: Style.fontSize

            // Not called `enabled` -- that name already belongs to Item,
            // and shadowing it would silently disable input on the button.
            readonly property bool actionAvailable:
                root.hasPlayer && root.player[button.modelData.capability]
            opacity: !button.actionAvailable ? 0.35 : (hover.hovered ? 1.0 : 0.75)

            Behavior on opacity {
                NumberAnimation { duration: Style.animDuration }
            }

            HoverHandler { id: hover }

            TapHandler {
                enabled: button.actionAvailable
                onTapped: {
                    switch (button.modelData.action) {
                    case "previous": root.player.previous(); break;
                    case "next":     root.player.next();     break;
                    case "toggle":   root.player.togglePlaying(); break;
                    }
                }
            }
        }
    }
}
