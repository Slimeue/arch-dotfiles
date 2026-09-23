pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// The wallpaper palette, read straight from the manager's machine-readable
// state file. matugen rewrites that file on every wallpaper change or
// light/dark toggle, `watchChanges` notices, and the bar recolours itself —
// no template, no reload signal, no entry in theme/config.toml.
//
// Every property carries a literal fallback, so a missing or half-written
// palette.json costs you the wallpaper colours, never a bar that fails to
// start. The fallbacks are the dark-mode values from the palette that was
// current when this was written.
Singleton {
    id: root

    readonly property color primary: json.primary
    readonly property color onPrimary: json.on_primary
    readonly property color surface: json.surface
    readonly property color onSurface: json.on_surface
    readonly property color onSurfaceVar: json.on_surface_variant
    readonly property color container: json.surface_container
    readonly property color containerHi: json.surface_container_high
    readonly property color outline: json.outline
    readonly property color outlineVar: json.outline_variant
    readonly property color error: json.error
    readonly property color onError: json.on_error

    FileView {
        path: `${Quickshell.env("HOME")}/.config/theme/state/palette.json`
        watchChanges: true
        onFileChanged: reload()

        adapter: JsonAdapter {
            id: json
            property string primary: "#e4c36c"
            property string on_primary: "#3d2e00"
            property string surface: "#16130b"
            property string on_surface: "#eae1d4"
            property string on_surface_variant: "#cfc5b4"
            property string surface_container: "#231f17"
            property string surface_container_high: "#2e2a21"
            property string outline: "#989080"
            property string outline_variant: "#4c4639"
            property string error: "#ffb4ab"
            property string on_error: "#690005"
        }
    }
}
