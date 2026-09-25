#!/usr/bin/env bash
# Start the Quickshell config that was last picked.
# Quickshell keeps no state across reboots, so we replay it from cache.
# Usage: shell-restore.sh [--lock]
#   --lock  also lock the screen once the shell is up (session start, where it
#           stands in for a login screen): caelestia's own lock when that is the
#           restored config, hyprlock otherwise. If caelestia's IPC does not
#           answer within SHELL_RESTORE_LOCK_TIMEOUT seconds (default 15),
#           hyprlock is used instead so the session is never left unlocked.
set -euo pipefail

STATE="${XDG_CACHE_HOME:-$HOME/.cache}/current-quickshell"
QS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell"
APPLY="$HOME/.config/hypr/scripts/shell-apply.sh"

LOCK=0
[ "${1:-}" = --lock ] && LOCK=1

# Prefer the remembered config; otherwise the default one, else the first found.
NAME=""
[ -s "$STATE" ] && NAME="$(head -n1 "$STATE")"
if [ -z "$NAME" ] || [ ! -f "$QS_DIR/$NAME/shell.qml" ]; then
    if [ -f "$QS_DIR/CaelestiaReplicate/shell.qml" ]; then
        NAME="CaelestiaReplicate"
    else
        # -L: $QS_DIR is a stow symlink, and a config dir may be one too
        # (caelestia links to a git clone); find would not descend otherwise.
        NAME="$(find -L "$QS_DIR" -mindepth 2 -maxdepth 2 -name shell.qml \
            -printf '%h\n' | xargs -r -n1 basename | sort | head -n1)"
    fi
fi

if [ "$LOCK" -eq 0 ]; then
    [ -n "$NAME" ] && exec "$APPLY" "$NAME"
    exit 0
fi

# From here on every path must end in a lock -- a failed start included.
if [ -n "$NAME" ] && ! "$APPLY" "$NAME"; then
    echo "shell-restore: starting $NAME failed; locking with hyprlock" >&2
    NAME=""
fi

if [ "$NAME" = caelestia ]; then
    # The IPC only answers a few seconds after launch; isLocked is a harmless
    # probe for that (0.2s steps).
    TIMEOUT="${SHELL_RESTORE_LOCK_TIMEOUT:-15}"
    for _ in $(seq 1 $((TIMEOUT * 5))); do
        qs ipc -c caelestia call lock isLocked >/dev/null 2>&1 && break
        sleep 0.2
    done
    if qs ipc -c caelestia call lock lock >/dev/null 2>&1; then
        exit 0
    fi
    echo "shell-restore: caelestia lock IPC did not answer within ${TIMEOUT}s; locking with hyprlock" >&2
fi

exec hyprlock
