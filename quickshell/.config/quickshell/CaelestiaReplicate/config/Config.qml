pragma Singleton

import QtQuick
import Quickshell

// User-facing options: what the bar shows and how big it is.
//
// Separate from Appearance on purpose. Appearance is the design system and you
// rarely touch it; this is the file you actually edit. Caelestia keeps the same
// split (its `Tokens` vs its `Config`), except theirs is a JSON file parsed in
// C++ -- here it is just QML, reloaded when you save.
Singleton {
    readonly property QtObject bar: QtObject {
        // Width of the content column. Everything in the bar sizes itself
        // against this, so widening the bar widens its contents too.
        readonly property int innerWidth: 40

        // Bar entries, top to bottom. Reorder these lines to reorder the bar;
        // set enabled to false to hide one without deleting it.
        //
        // "spacer" is not a widget -- it is an expanding gap. The single spacer
        // below is what pushes the clock and power button to the bottom.
        readonly property var entries: [
            { id: "logo", enabled: true },
            { id: "workspaces", enabled: true },
            { id: "activeWindow", enabled: true },
            { id: "media", enabled: false },
            { id: "spacer", enabled: true },
            { id: "tray", enabled: true },
            { id: "statusIcons", enabled: true },
            { id: "clock", enabled: true },
            { id: "power", enabled: true }
        ]

        readonly property QtObject workspaces: QtObject {
            // How many workspaces to draw. With showUnoccupied the bar shows
            // this many as a fixed group; without it, only workspaces that
            // have windows (plus the active one) appear.
            readonly property int shown: 5
            readonly property bool showUnoccupied: true
            // Only count workspaces belonging to this bar's monitor.
            readonly property bool perMonitor: true
            // The merged rounded backdrop behind runs of occupied workspaces.
            readonly property bool occupiedBg: true
            // The sliding pill marking the focused workspace.
            readonly property bool activeIndicator: true
            // Whether that pill stretches as it travels instead of sliding rigidly.
            readonly property bool activeTrail: true
        }

        readonly property QtObject activeWindow: QtObject {
            // Title text is rotated to run down the bar. This caps how far.
            readonly property int maxLength: 220
            // "kitty — ~/src" becomes "~/src": keep only the last dash-separated part.
            readonly property bool compact: true
        }

        readonly property QtObject clock: QtObject {
            readonly property bool showIcon: true
            readonly property bool showDate: true
            readonly property bool showSeconds: false
            readonly property bool twelveHour: true
        }

        readonly property QtObject media: QtObject {
            readonly property int artSize: 28
        }
    }

    // Scroll gestures on the bar. Workspaces scroll over the workspace widget;
    // volume and brightness use the top and bottom half of everything else.
    readonly property QtObject scrollActions: QtObject {
        readonly property bool workspaces: true
        readonly property bool volume: true
    }
}
