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

## Switching

Press `SUPER + CTRL + W` for the wofi menu, or call the applier directly:

```sh
~/.config/hypr/scripts/shell-apply.sh CaelestiaReplicate
```

Either way the old instance is killed before the new one starts, and the name
is written to `~/.cache/current-quickshell`. Hyprland replays that choice at
login through `shell-restore.sh`, which falls back to `CaelestiaReplicate` if
the cache is missing or names a config that no longer exists.

## Adding a config

Make a directory with a `shell.qml` in it. The picker lists whatever it finds,
so there is nothing else to register.
