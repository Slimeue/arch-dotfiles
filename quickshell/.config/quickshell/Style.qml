pragma Singleton

import QtQuick
import Quickshell

// Shared look-and-feel. Geometry is set here; colour is delegated to
// Theme, which tracks the wallpaper. Changing a value here restyles the
// whole bar on reload.
Singleton {
    // Geometry. The margins and radii match what the waybar stylesheet used,
    // so the bar keeps sitting where your eye already expects it.
    property int barHeight: 38
    property int islandHeight: 28
    property int islandRadius: 8
    property int islandPadding: 10
    property int islandSpacing: 8
    property int groupSpacing: 4      // gap between islands within a group
    property int screenMargin: 10

    // Colours — all forwarded from the wallpaper palette.
    property color islandBg: Theme.containerHi
    property color fg: Theme.onSurface
    property color fgDim: Theme.onSurfaceVar
    property color accent: Theme.primary
    property color onAccent: Theme.onPrimary
    property color urgent: Theme.error
    property color onUrgent: Theme.onError

    // Type. Nerd Font so tray fallbacks and glyphs render.
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 13

    // Motion. One duration for every transition keeps the bar feeling like
    // a single object rather than a row of independently animated widgets.
    property int animDuration: 150

    // Active window title. The island holds this width whatever the title is,
    // so the bar never reflows as you switch windows; titles that do not fit
    // scroll instead of eliding.
    property int activeWindowWidth: 120
    property int marqueeSpeed: 40     // px per second
    property int marqueePause: 1500   // ms held at each end of the scroll

    // Chrome. false gives separate pills; true puts every widget into one
    // continuous bar. The widgets themselves are identical either way.
    property bool singleBar: true

    // Media island.
    property int mediaArtSize: 18
    property int mediaMaxWidth: 220   // track text elides past this
}
