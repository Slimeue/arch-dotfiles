#!/usr/bin/env bash
# Switch to a Quickshell config and remember it. Used by both the picker and
# the restorer.
# Usage: shell-apply.sh <Name>
set -euo pipefail

STATE="${XDG_CACHE_HOME:-$HOME/.cache}/current-quickshell"
QS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell"
NAME="${1:-}"

notify() {
    command -v notify-send >/dev/null 2>&1 && notify-send "Quickshell" "$1" || true
}

[ -n "$NAME" ] || { echo "shell-apply: no config name given" >&2; notify "No config name given"; exit 1; }
[ -f "$QS_DIR/$NAME/shell.qml" ] || {
    echo "shell-apply: no such config: $NAME" >&2
    notify "No such config: $NAME"
    exit 1
}

# Only one bar at a time -- the old instance keeps its layer shell reservation
# until it is gone, so wait for it to actually die (max ~3s). /usr/bin/qs is a
# symlink to quickshell, so an instance answers to either name.
PROC='quickshell|qs'
pkill -x "$PROC" || true
for _ in $(seq 1 30); do
    pgrep -x "$PROC" >/dev/null 2>&1 || break
    sleep 0.1
done
pgrep -x "$PROC" >/dev/null 2>&1 && pkill -9 -x "$PROC" || true

qs -c "$NAME" -n -d

printf '%s\n' "$NAME" > "$STATE"

notify "Switched to $NAME"
