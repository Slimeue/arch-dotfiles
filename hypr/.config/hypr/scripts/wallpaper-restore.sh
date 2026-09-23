#!/usr/bin/env bash
# Start the wallpaper daemon and re-apply the last used wallpaper.
# awww/swww keeps no state across reboots, so we replay it from cache.
set -euo pipefail

STATE="${XDG_CACHE_HOME:-$HOME/.cache}/current-wallpaper"
WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Pictures/Wallpapers}"
APPLY="$HOME/.config/hypr/scripts/wallpaper-apply.sh"

DAEMON="$(command -v awww-daemon || command -v swww-daemon || true)"
[ -n "$DAEMON" ] || { echo "wallpaper-restore: daemon not found" >&2; exit 1; }

# Start the daemon only if it is not already up.
pgrep -x "$(basename "$DAEMON")" >/dev/null 2>&1 || setsid "$DAEMON" >/dev/null 2>&1 &

# Wait for the daemon socket to accept commands (max ~5s).
BIN="$(command -v awww || command -v swww)"
for _ in $(seq 1 50); do
    "$BIN" query >/dev/null 2>&1 && break
    sleep 0.1
done

# Prefer the remembered wallpaper; otherwise fall back to the first in the dir.
WALL=""
[ -s "$STATE" ] && WALL="$(head -n1 "$STATE")"
if [ -z "$WALL" ] || [ ! -f "$WALL" ]; then
    WALL="$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \
        \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \
           -o -iname '*.webp' -o -iname '*.gif' \) | sort | head -n1)"
fi

[ -n "$WALL" ] && exec "$APPLY" "$WALL" --no-transition
