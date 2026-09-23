# quickshell

A vertical left-edge bar for Hyprland, modelled on [caelestia-dots/shell][cae]
but written in plain QML — no C++ plugin, no build step. Saving any file
hot-reloads it.

[cae]: https://github.com/caelestia-dots/shell

## Layout

Directories are QML modules. Quickshell exposes the config root as `qs`, so
`services/Colours.qml` is imported as `qs.services` — there is no `qmldir` to
maintain, and a `pragma Singleton` file is registered as a singleton
automatically.

```
config/      design tokens and user options        no dependencies
utils/       pure lookup tables                    no dependencies
services/    singletons holding live system state  depends on config
components/  generic widgets, nothing bar-specific depends on config, services
modules/     the surfaces themselves               depends on all of the above
shell.qml    composition root, declares no UI
```

Imports only point down that list. A module may use a component, a component
may use a service, and nothing reaches back up. Adding a launcher or dashboard
means a new directory under `modules/` and one line in `shell.qml`.

## Where to change things

| Want to | Edit |
|---|---|
| Reorder, add or hide a bar widget | `config/Config.qml` → `bar.entries` |
| Change bar width, workspace count, clock format | `config/Config.qml` |
| Change spacing, radii, fonts, animation speed | `config/Appearance.qml` |
| Change colours | nothing here — see below |
| Add an icon | `utils/Icons.qml` |

## Colours

`services/Colours.qml` reads `~/.config/theme/state/palette.json`, which matugen
rewrites on every wallpaper change. The bar recolours itself live; there is no
template for it in `~/.config/theme/config.toml` and nothing to reload.

Every colour has a literal fallback, so a missing or half-written palette costs
you the wallpaper colours, never a bar that fails to start.

## Adding an icon

Glyphs come from the Material Design block inside JetBrainsMono Nerd Font.
Codepoints there are **five** hex digits, and `\uXXXX` in JavaScript consumes
only four — `"0"` silently means U+F020 followed by `"0"`, which renders a
plausible wrong icon rather than an error. Always write `"\u{f0200}"`.

## Restoring the previous horizontal bar

```sh
git -C ~/dotfiles checkout pre-caelestia-bar -- quickshell/
```

Tarball copies are also in `~/backups/quickshell-<timestamp>.tar.gz`.
