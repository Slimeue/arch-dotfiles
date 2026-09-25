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

# caelestia ships its own notification daemon. Everything else relies on dunst,
# which D-Bus starts on demand.
owns_notifications() { [ "$1" = caelestia ]; }

# True once org.freedesktop.Notifications is owned by something other than
# dunst. busctl status only queries the owner, so it never triggers activation.
notifications_owned_by_shell() {
    local comm
    comm=$(busctl --user status org.freedesktop.Notifications 2>/dev/null \
        | sed -n 's/^Comm=//p') || true
    [ -n "$comm" ] && [ "$comm" != dunst ]
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

# A running dunst holds the notification name and the shell's own daemon would
# never get it, so clear it out first (max ~2s).
if owns_notifications "$NAME"; then
    pkill -x dunst || true
    for _ in $(seq 1 20); do
        pgrep -x dunst >/dev/null 2>&1 || break
        sleep 0.1
    done
fi

qs -c "$NAME" -n -d

printf '%s\n' "$NAME" > "$STATE"

if owns_notifications "$NAME"; then
    # The shell registers its server a moment after launch. Notifying before
    # that would make D-Bus activate dunst, which then keeps the name for the
    # rest of the session -- so wait for it (max ~8s) or stay quiet.
    for _ in $(seq 1 80); do
        notifications_owned_by_shell && break
        sleep 0.1
    done
    if notifications_owned_by_shell; then
        notify "Switched to $NAME"
    else
        echo "shell-apply: $NAME did not claim org.freedesktop.Notifications; skipping notification" >&2
    fi
else
    notify "Switched to $NAME"
fi
