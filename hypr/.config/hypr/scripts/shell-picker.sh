#!/usr/bin/env bash
# Pick a Quickshell config from $QS_DIR with wofi, then apply it.
set -euo pipefail

STATE="${XDG_CACHE_HOME:-$HOME/.cache}/current-quickshell"
QS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell"
APPLY="$HOME/.config/hypr/scripts/shell-apply.sh"

[ -d "$QS_DIR" ] || { notify-send "Quickshell" "No such directory: $QS_DIR"; exit 1; }

# A config is any immediate subdirectory holding a shell.qml. -L: $QS_DIR is a
# stow symlink, and a config dir may be one too (caelestia links to a git
# clone); find would not descend into either otherwise.
mapfile -t CONFIGS < <(find -L "$QS_DIR" -mindepth 2 -maxdepth 2 -name shell.qml \
    -printf '%h\n' | xargs -r -n1 basename | sort)

[ "${#CONFIGS[@]}" -gt 0 ] || { notify-send "Quickshell" "No configs in $QS_DIR"; exit 1; }

CURRENT=""
[ -s "$STATE" ] && CURRENT="$(head -n1 "$STATE")"

# Bullet the active config; pad the rest so the names still line up.
declare -A BY_LABEL
menu=""
for c in "${CONFIGS[@]}"; do
    if [ "$c" = "$CURRENT" ]; then
        label="● $c"
    else
        label="  $c"
    fi
    BY_LABEL["$label"]="$c"
    menu+="$label"$'\n'
done

choice="$(printf '%s' "$menu" | wofi --dmenu --prompt "Quickshell" --insensitive)" || exit 0
[ -n "$choice" ] || exit 0

target="${BY_LABEL[$choice]:-}"
[ -n "$target" ] || exit 0

"$APPLY" "$target"
