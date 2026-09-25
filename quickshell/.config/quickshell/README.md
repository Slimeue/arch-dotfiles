# quickshell

Each subdirectory here is a complete, self-contained Quickshell config,
launched with `qs -c <Name>`. There is deliberately no `shell.qml` at this
level: a root config becomes the nameless "default" that a bare `qs` runs,
outside anything the picker knows about. One consequence: `qs list` now needs
`--all`, since without `-c` it looks only for that default.

## The configs

- **CaelestiaReplicate** — vertical left-edge bar modelled on caelestia-dots.
  See its own README for the module layout.
- **MyOwnShell** — the original horizontal island bar: clock, media controls,
  window title, workspaces and tray.
- **caelestia** — symlink to the upstream caelestia-dots/shell clone at
  `~/github-repos/shell`. The `caelestia` CLI drives it too:
  `caelestia shell -d` starts it, `caelestia shell -k` kills it. After a
  `git pull` in the clone, rebuild and reinstall the C++ parts from there:
  `cmake --build build && sudo cmake --install build`.

## Keybinds

caelestia's binds live in `hypr/hyprland.lua`, in the block after the user
keybinds, and go through `scripts/shell-bind.sh` so they only fire while
caelestia is the running config. Keys it shares with existing binds fall back
under the other configs: `SUPER + L` to hyprlock, `SUPER + V` to toggle
floating, `SUPER + SHIFT + S` to hyprshot, and the media and brightness keys to
playerctl and brightnessctl. The rest are either Hyprland global shortcuts,
which do nothing when no caelestia instance has registered them, or `caelestia`
CLI calls that the wrapper skips.

## Switching

Press `SUPER + CTRL + W` for the wofi menu, or call the applier directly:

```sh
~/.config/hypr/scripts/shell-apply.sh CaelestiaReplicate
```

Either way the old instance is killed before the new one starts, and the name
is written to `~/.cache/current-quickshell`. Hyprland replays that choice at
login through `shell-restore.sh`, which falls back to `CaelestiaReplicate` if
the cache is missing or names a config that no longer exists.

Switching to `caelestia` also stops dunst, because caelestia is its own
notification daemon and cannot claim the name while dunst holds it. Switching
away lets D-Bus start dunst again on the next notification.

## Adding a config

Make a directory with a `shell.qml` in it. The picker lists whatever it finds,
so there is nothing else to register. A symlink to a directory works too,
since the picker follows symlinks.
