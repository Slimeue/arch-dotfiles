#!/usr/bin/env bash
# Pick a wallpaper from $WALLPAPER_DIR with wofi, then apply it.
set -euo pipefail

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Pictures/Wallpapers}"
APPLY="$HOME/.config/hypr/scripts/wallpaper-apply.sh"

[ -d "$WALLPAPER_DIR" ] || { notify-send "Wallpaper" "No such directory: $WALLPAPER_DIR"; exit 1; }

# Collect images, newest first is arbitrary -- sort by name for a stable menu.
mapfile -t WALLS < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \
    \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \
       -o -iname '*.webp' -o -iname '*.gif' \) | sort)

[ "${#WALLS[@]}" -gt 0 ] || { notify-send "Wallpaper" "No images in $WALLPAPER_DIR"; exit 1; }

# Show "name" to the user, keep the full path keyed off it.
declare -A BY_LABEL
menu=""
for w in "${WALLS[@]}"; do
    label="$(basename "${w%.*}")"
    BY_LABEL["$label"]="$w"
    menu+="$label"$'\n'
done

choice="$(printf '%s' "$menu" | wofi --dmenu --prompt "Wallpaper" --insensitive)" || exit 0
[ -n "$choice" ] || exit 0

target="${BY_LABEL[$choice]:-}"
[ -n "$target" ] || exit 0

"$APPLY" "$target"
