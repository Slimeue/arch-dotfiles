pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// The wallpaper palette, read straight from the theme manager's
// machine-readable state file.
//
// matugen rewrites that file on every wallpaper change or light/dark toggle,
// `watchChanges` notices, and the bar recolours itself -- no template, no
// reload signal, no entry in theme/config.toml.
//
// Every property carries a literal fallback, so a missing or half-written
// palette.json costs you the wallpaper colours, never a bar that fails to
// start. The fallbacks are the dark-mode values current when this was written.
//
// This is the one service caelestia does differently: it runs matugen itself
// and keeps the palette in memory. Reading a file the theme manager already
// writes is less code and survives the shell being restarted.
Singleton {
    id: root

    // Accent roles.
    readonly property color primary: json.primary
    readonly property color onPrimary: json.on_primary
    readonly property color primaryContainer: json.primary_container
    readonly property color onPrimaryContainer: json.on_primary_container
    readonly property color secondary: json.secondary
    readonly property color onSecondary: json.on_secondary
    readonly property color tertiary: json.tertiary
    readonly property color onTertiary: json.on_tertiary

    // Neutral surfaces, lowest (furthest back) to highest (most raised).
    readonly property color surface: json.surface
    readonly property color surfaceLowest: json.surface_container_lowest
    readonly property color surfaceLow: json.surface_container_low
    readonly property color surfaceContainer: json.surface_container
    readonly property color surfaceHigh: json.surface_container_high
    readonly property color surfaceHighest: json.surface_container_highest

    // Foregrounds and lines.
    readonly property color onSurface: json.on_surface
    readonly property color onSurfaceVar: json.on_surface_variant
    readonly property color outline: json.outline
    readonly property color outlineVar: json.outline_variant

    readonly property color error: json.error
    readonly property color onError: json.on_error

    // True when the palette is a light one. matugen does not say so directly,
    // so it is inferred from how bright the surface is -- which is the same
    // thing, and keeps this independent of the theme manager's mode file.
    readonly property bool light: root.luminance(root.surface) > 0.5

    // Perceptual brightness (ITU-R BT.601 weights). Used for `light` above and
    // available to any widget that needs to pick a readable foreground.
    function luminance(c: color): real {
        return Math.sqrt(0.299 * (c.r ** 2) + 0.587 * (c.g ** 2) + 0.114 * (c.b ** 2));
    }

    // Blend `amount` of `over` into `base`. Cheap stand-in for M3's state
    // layers, used for hover and press tints.
    function mix(base: color, over: color, amount: real): color {
        return Qt.rgba(base.r + (over.r - base.r) * amount, base.g + (over.g - base.g) * amount, base.b + (over.b - base.b) * amount, base.a);
    }

    FileView {
        path: `${Quickshell.env("HOME")}/.config/theme/state/palette.json`
        watchChanges: true
        onFileChanged: reload()

        adapter: JsonAdapter {
            id: json

            property string primary: "#e4c36c"
            property string on_primary: "#3d2e00"
            property string primary_container: "#584400"
            property string on_primary_container: "#ffdf95"
            property string secondary: "#d6c5a0"
            property string on_secondary: "#3a2f15"
            property string tertiary: "#b0cfa6"
            property string on_tertiary: "#1d3719"
            property string surface: "#16130b"
            property string on_surface: "#eae1d4"
            property string on_surface_variant: "#cfc5b4"
            property string surface_container_lowest: "#100e07"
            property string surface_container_low: "#1e1b13"
            property string surface_container: "#231f17"
            property string surface_container_high: "#2e2a21"
            property string surface_container_highest: "#39342b"
            property string outline: "#989080"
            property string outline_variant: "#4c4639"
            property string error: "#ffb4ab"
            property string on_error: "#690005"
        }
    }
}
