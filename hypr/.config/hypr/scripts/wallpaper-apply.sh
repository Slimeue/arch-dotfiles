#!/usr/bin/env bash
# Apply a wallpaper and remember it. Used by both the picker and the restorer.
# Usage: wallpaper-apply.sh /path/to/image [--no-transition]
set -euo pipefail

STATE="${XDG_CACHE_HOME:-$HOME/.cache}/current-wallpaper"
WALL="${1:-}"

# The project was renamed swww -> awww; support either binary.
BIN="$(command -v awww || command -v swww || true)"
[ -n "$BIN" ] || { echo "wallpaper-apply: neither awww nor swww found" >&2; exit 1; }

[ -n "$WALL" ] || { echo "wallpaper-apply: no image given" >&2; exit 1; }
[ -f "$WALL" ] || { echo "wallpaper-apply: not a file: $WALL" >&2; exit 1; }

if [ "${2:-}" = "--no-transition" ]; then
    "$BIN" img "$WALL" --transition-type none --resize crop
else
    "$BIN" img "$WALL" \
        --transition-type fade \
        --transition-duration 1 \
        --transition-fps 60 \
        --resize crop
fi

printf '%s\n' "$WALL" > "$STATE"

# Re-theme every app to match the new wallpaper. This runs for the picker,
# the login restore and any direct call, so the theme can never drift from
# the wallpaper. Non-fatal: a theming failure must not leave you with no
# wallpaper.
THEME="$HOME/.config/theme/theme-apply.sh"
[ -x "$THEME" ] && "$THEME" "$WALL" --quiet || true
