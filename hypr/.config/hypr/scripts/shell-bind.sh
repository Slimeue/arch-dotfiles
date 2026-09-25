#!/usr/bin/env bash
# Gate a caelestia keybind on caelestia being the running quickshell config.
# Usage: shell-bind.sh "<caelestia command>" "<fallback command>"
# Under the other configs (CaelestiaReplicate, MyOwnShell) the fallback runs
# instead, so a key caelestia shares with an existing bind keeps its original
# action; an empty fallback makes the bind a no-op there.
set -euo pipefail

if pgrep -f '^qs -c caelestia -n' >/dev/null; then
    exec bash -c "$1"
elif [[ -n ${2:-} ]]; then
    exec bash -c "$2"
fi
exit 0
