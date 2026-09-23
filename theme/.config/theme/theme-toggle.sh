#!/usr/bin/env bash
# Flip between the light and dark variant of the current wallpaper's theme,
# without changing the wallpaper. Convenience wrapper for a keybind.
exec "$HOME/.config/theme/theme-apply.sh" --toggle "$@"
