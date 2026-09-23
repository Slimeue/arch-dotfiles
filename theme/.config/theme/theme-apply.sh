#!/usr/bin/env bash
# Generate a colour theme from a wallpaper and apply it everywhere.
#
#   theme-apply.sh [IMAGE] [--dark|--light|--toggle] [--quiet]
#
# With no IMAGE, re-themes from the wallpaper recorded in
# ~/.cache/current-wallpaper -- so it can be run standalone to just flip
# light/dark without touching the wallpaper.
#
# Called automatically by wallpaper-apply.sh, which every wallpaper change
# routes through (picker, restore-on-login, or a direct call). That is the
# single integration point: theme and wallpaper cannot drift apart.
set -euo pipefail

THEME_DIR="$HOME/.config/theme"
STATE_DIR="$THEME_DIR/state"
MODE_FILE="$STATE_DIR/mode"
WALL_STATE="${XDG_CACHE_HOME:-$HOME/.cache}/current-wallpaper"
PALETTE="$STATE_DIR/palette.json"

mkdir -p "$STATE_DIR"

WALL=""
MODE=""
QUIET=0

for arg in "$@"; do
    case "$arg" in
        --dark)   MODE="dark"  ;;
        --light)  MODE="light" ;;
        --toggle) MODE="toggle";;
        --quiet)  QUIET=1      ;;
        -*)       echo "theme-apply: unknown option: $arg" >&2; exit 2 ;;
        *)        WALL="$arg"  ;;
    esac
done

log() { [ "$QUIET" -eq 1 ] || printf 'theme: %s\n' "$*"; }

command -v matugen >/dev/null 2>&1 || {
    echo "theme-apply: matugen not found. Install it with: sudo pacman -S matugen" >&2
    exit 1
}

# ---------------------------------------------------------------- mode ----
# Dark is the default; the stored mode persists across wallpaper changes so
# a new wallpaper does not silently flip you back to dark.
CURRENT_MODE="dark"
[ -s "$MODE_FILE" ] && CURRENT_MODE="$(head -n1 "$MODE_FILE")"

case "$MODE" in
    "")       MODE="$CURRENT_MODE" ;;
    toggle)   [ "$CURRENT_MODE" = "dark" ] && MODE="light" || MODE="dark" ;;
esac
printf '%s\n' "$MODE" > "$MODE_FILE"

# ----------------------------------------------------------- wallpaper ----
if [ -z "$WALL" ]; then
    [ -s "$WALL_STATE" ] && WALL="$(head -n1 "$WALL_STATE")"
fi
[ -n "$WALL" ] || { echo "theme-apply: no wallpaper given and none recorded in $WALL_STATE" >&2; exit 1; }
[ -f "$WALL" ] || { echo "theme-apply: not a file: $WALL" >&2; exit 1; }

log "generating $MODE theme from $(basename "$WALL")"

# matugen writes into these; create them so a first run on a fresh machine
# does not fail on a missing directory.
mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0" "$HOME/.config/qt6ct/colors"

# --prefer is REQUIRED for automation. When an image yields several candidate
# source colours, matugen 4.x prompts for a choice, and when it cannot detect a
# terminal it aborts instead. Run from wallpaper-apply.sh there is no terminal,
# so without this the theme would silently never regenerate.
#   saturation = pick the most vivid candidate -> the most distinctive accent.
# Override per-run with: THEME_PREFER=darkness theme-apply.sh
#   (darkness | lightness | saturation | less-saturation | value | closest-to-fallback)
PREFER="${THEME_PREFER:-saturation}"

# --fallback-color covers wallpapers with no usable colour at all (near-black,
# near-white, heavy grain); without it those abort rather than degrading.
matugen image "$WALL" \
    --mode "$MODE" \
    --prefer "$PREFER" \
    --fallback-color "#8aadf4" \
    --config "$THEME_DIR/config.toml" >/dev/null

# ------------------------------------------------------------- reloads ----
# Ordering matters only in that Hyprland is applied live via hyprctl, which
# needs the freshly written palette.json to exist first.

# kitty: SIGUSR1 makes every running instance re-read its config, including
# the colors.conf we just rewrote. No restart, no lost scrollback.
if pgrep -x kitty >/dev/null 2>&1; then
    pkill -USR1 -x kitty && log "reloaded kitty"
fi

# quickshell: nothing to do. The bar reads state/palette.json directly
# through a FileView with watchChanges, so writing that file above has
# already recoloured it. This is why there is no [templates.quickshell]
# block in config.toml -- the bar consumes the palette, it is not a
# render target.

# dunst: prefer dunstctl (in-place reload, keeps the notification history).
# Fall back to killing it -- dunst is D-Bus activated and respawns themed.
if pgrep -x dunst >/dev/null 2>&1; then
    if command -v dunstctl >/dev/null 2>&1 && dunstctl reload >/dev/null 2>&1; then
        log "reloaded dunst"
    else
        pkill -x dunst && log "restarted dunst"
    fi
fi

# Hyprland: apply borders live so there is no config-reload flash.
#
# NOTE: `hyprctl keyword` does NOT work here. Your hyprland config is Lua, and
# Hyprland rejects keyword against a non-legacy parser with:
#   "keyword can't work with non-legacy parsers. Use eval."
# So we push a partial hl.config through `hyprctl eval` instead. colors.lua is
# what makes the change survive a restart; this is only for immediate effect.
if command -v hyprctl >/dev/null 2>&1 && [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ] && [ -s "$PALETTE" ]; then
    p() { jq -r ".$1" "$PALETTE" | tr -d '#'; }
    prim="$(p primary)"; tert="$(p tertiary)"; outl="$(p outline_variant)"
    if [ -n "$prim" ] && [ "$prim" != "null" ]; then
        # Errors are surfaced rather than swallowed -- a silent failure here is
        # exactly the bug that made this look like it worked when it did not.
        result="$(hyprctl eval "hl.config({ general = { col = { \
            active_border = { colors = {\"rgba(${prim}ee)\", \"rgba(${tert}ee)\"}, angle = 45 }, \
            inactive_border = \"rgba(${outl}aa)\" } } })" 2>&1)"
        if [ "$result" = "ok" ]; then
            log "applied Hyprland borders"
        else
            echo "theme-apply: hyprctl eval failed: $result" >&2
        fi
    fi
fi

# qt6ct.conf self-repair. Opening the qt6ct GUI rewrites this file through
# QSettings and resets color_scheme_path to a stock scheme, which silently
# unthemes every Qt app. Re-assert the two settings that matter on every run.
QT6CT_CONF="$HOME/.config/qt6ct/qt6ct.conf"
QT6CT_SCHEME="$HOME/.config/qt6ct/colors/wallpaper.conf"
if [ -f "$QT6CT_CONF" ]; then
    if ! grep -qx "color_scheme_path=$QT6CT_SCHEME" "$QT6CT_CONF" \
       || ! grep -qx "custom_palette=true" "$QT6CT_CONF"; then
        sed -i -e "s|^color_scheme_path=.*|color_scheme_path=$QT6CT_SCHEME|" \
               -e "s|^custom_palette=.*|custom_palette=true|" "$QT6CT_CONF"
        log "repaired qt6ct.conf (it had been reset)"
    fi
fi

# GTK and Qt apps read their colours at startup only; nothing to signal.
# Nudge the GTK dark/light preference so apps that follow it agree with us.
if command -v gsettings >/dev/null 2>&1; then
    if [ "$MODE" = "dark" ]; then
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
    else
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-light' 2>/dev/null || true
    fi
fi

log "done ($MODE)"
