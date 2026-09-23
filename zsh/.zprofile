# Start Hyprland automatically on tty1 (replaces the display manager).
# hyprlock is launched by hyprland.lua at session start, so the first thing
# on screen is the lock prompt.
if [[ -z $DISPLAY && $(tty) == /dev/tty1 ]]; then
  exec start-hyprland
fi
