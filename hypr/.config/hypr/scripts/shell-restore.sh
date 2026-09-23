#!/usr/bin/env bash
# Start the Quickshell config that was last picked.
# Quickshell keeps no state across reboots, so we replay it from cache.
set -euo pipefail

STATE="${XDG_CACHE_HOME:-$HOME/.cache}/current-quickshell"
QS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell"
APPLY="$HOME/.config/hypr/scripts/shell-apply.sh"

# Prefer the remembered config; otherwise the default one, else the first found.
NAME=""
[ -s "$STATE" ] && NAME="$(head -n1 "$STATE")"
if [ -z "$NAME" ] || [ ! -f "$QS_DIR/$NAME/shell.qml" ]; then
    if [ -f "$QS_DIR/CaelestiaReplicate/shell.qml" ]; then
        NAME="CaelestiaReplicate"
    else
        NAME="$(find -H "$QS_DIR" -mindepth 2 -maxdepth 2 -name shell.qml \
            -printf '%h\n' | xargs -r -n1 basename | sort | head -n1)"
    fi
fi

[ -n "$NAME" ] && exec "$APPLY" "$NAME"
