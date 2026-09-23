pragma Singleton

import QtQuick
import Quickshell

// Design tokens: the vocabulary every other file sizes and animates with.
//
// Nothing here names a widget. A file asks for `Appearance.padding.medium`,
// never `12`, so one edit here restyles the whole shell consistently.
//
// The numbers are Material 3 Expressive's, taken from caelestia's token set so
// the proportions match the bar this imitates. Colour is deliberately absent --
// that lives in services/Colours.qml, because colour tracks the wallpaper and
// these do not.
Singleton {
    // Corner radii. `full` is deliberately larger than any widget: Rectangle
    // clamps radius to half the shorter side, so `full` always means "pill".
    readonly property QtObject rounding: QtObject {
        readonly property int extraSmall: 4
        readonly property int small: 8
        readonly property int medium: 12
        readonly property int large: 16
        readonly property int extraLarge: 28
        readonly property int full: 1000
    }

    // Gaps between sibling items.
    readonly property QtObject spacing: QtObject {
        readonly property int extraSmall: 4
        readonly property int small: 8
        readonly property int medium: 12
        readonly property int large: 16
        readonly property int extraLarge: 28
    }

    // Space between a container's edge and its contents.
    readonly property QtObject padding: QtObject {
        readonly property int extraSmall: 4
        readonly property int small: 8
        readonly property int medium: 12
        readonly property int large: 16
        readonly property int extraLarge: 28
    }

    readonly property QtObject font: QtObject {
        // Nerd Font, because the icon glyphs in utils/Icons.qml live in its
        // Material Design range. Swapping this family without swapping that
        // table gives you tofu boxes.
        readonly property string family: "JetBrainsMono Nerd Font"
        readonly property QtObject size: QtObject {
            readonly property int small: 11
            readonly property int smaller: 12
            readonly property int normal: 13
            readonly property int larger: 15
            readonly property int large: 18
            readonly property int extraLarge: 28
        }
    }

    readonly property QtObject anim: QtObject {
        readonly property QtObject durations: QtObject {
            readonly property int small: 200
            readonly property int normal: 400
            readonly property int large: 600
            // "Spatial" = something moving or resizing; "effects" = something
            // fading or recolouring. Motion reads slower than colour, so the
            // two get different budgets.
            readonly property int expressiveFastSpatial: 350
            readonly property int expressiveDefaultSpatial: 500
            readonly property int expressiveFastEffects: 150
            readonly property int expressiveDefaultEffects: 200
        }

        // Cubic bezier splines, flat [x1,y1, x2,y2, x,y, ...] ending at 1,1.
        // `emphasized` is two segments, which is what gives M3 its
        // slow-start / fast-middle / soft-landing feel; the rest are one.
        readonly property var curves: QtObject {
            readonly property var emphasized: [0.05, 0, 0.133333, 0.06, 0.166667, 0.4, 0.208333, 0.82, 0.25, 1, 1, 1]
            readonly property var standard: [0.2, 0, 0, 1, 1, 1]
            readonly property var standardDecel: [0, 0, 0, 1, 1, 1]
            // Overshoots past 1 then settles -- the springy one. Used by the
            // workspace indicator so it stretches as it travels.
            readonly property var expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1, 1, 1]
            readonly property var expressiveDefaultEffects: [0.34, 0.8, 0.34, 1, 1, 1]
        }
    }
}
