pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.components
import qs.config
import qs.services

// One bar window per monitor.
//
// This file owns everything about *being a window*: which screen, which edge,
// how much space the compositor should reserve. Bar.qml owns what is drawn
// inside. Keeping those apart is why the bar could be moved to the right edge,
// or made to auto-hide, without touching a single widget.
//
// Anchoring left+top+bottom and leaving `right` unset is what makes the bar
// vertical: the panel spans the full screen height, and its implicitWidth
// becomes the exclusive zone the compositor reserves.
Variants {
    model: Quickshell.screens

    PanelWindow {
        id: win

        required property var modelData

        screen: win.modelData

        anchors {
            top: true
            bottom: true
            left: true
        }

        // The reserved strip: content plus a margin either side.
        implicitWidth: Config.bar.innerWidth + Appearance.padding.small * 2

        // Transparent, with the bar's own background drawn below. Leaving the
        // window itself transparent lets the rounded pills inside sit on the
        // wallpaper rather than on a grey slab.
        color: "transparent"

        StyledRect {
            anchors.fill: parent
            color: Colours.surface
        }

        Bar {
            anchors.fill: parent
            anchors.topMargin: Appearance.padding.medium
            anchors.bottomMargin: Appearance.padding.medium

            screen: win.modelData
            window: win
        }
    }
}
