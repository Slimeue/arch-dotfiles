# Keybinds

Everything I press daily, in one place. Updated 2026-09-25.

**Reading this file**

| Symbol | Means |
| --- | --- |
| `SUPER` | The Windows key. `mainMod` in `hyprland.lua`. |
| `Leader` | Space, in Neovim. `<leader>ff` = Space, f, f. |
| `kitty_mod` | Ctrl+Shift, in kitty. |
| gated | Only does the caelestia action while the caelestia shell is running. Under other shells the fallback in brackets runs. |

Where each set lives, so you can change it:

| Tool | File |
| --- | --- |
| Hyprland | `~/.config/hypr/hyprland.lua` (alias `hyprconfig`) |
| Caelestia Spotify window | `~/github-repos/shell/modules/spotify/` (see its README) |
| Caelestia clock window | `~/github-repos/shell/modules/clock/` (see its README) |
| Neovim | `~/.config/nvim/init.lua` and `lua/plugins/*.lua` (alias `nvimconfig`) |
| Kitty | `~/.config/kitty/kitty.conf` (all defaults, no custom maps) |
| Zsh | `~/.zshrc` (alias `zshconfig`) |

All of these are stow symlinks into `~/dotfiles`.

---

## Hyprland

### Apps and launchers

| Key | Does |
| --- | --- |
| `SUPER + Q` | Terminal (kitty) |
| `SUPER + E` | File manager |
| `SUPER + B` | LibreWolf |
| `SUPER + R` | wofi app menu |
| `SUPER` (tap) | Caelestia launcher |
| `SUPER + Period` | Emoji picker (caelestia) |
| `SUPER + V` | Clipboard history (gated; fallback: toggle floating) |
| `SUPER + ALT + V` | Clipboard history, delete mode |
| `SUPER + C` | Close window |
| `SUPER + M` | Exit Hyprland (via hyprshutdown if installed) |

### Focus and workspaces

| Key | Does |
| --- | --- |
| `SUPER + Arrows` | Move focus left / right / up / down |
| `SUPER + 1..9, 0` | Go to workspace 1 to 10 |
| `SUPER + SHIFT + 1..9, 0` | Send the focused window to that workspace |
| `SUPER + Scroll` | Next / previous workspace |
| `SUPER + K` | Caelestia overview of all workspaces |

### Window management (tiles and floaters)

Layout is dwindle: every new window splits the focused tile.

| Key | Does |
| --- | --- |
| `SUPER + SHIFT + Arrows` | Move the tile into the neighbouring slot. A floating window goes to that screen edge, 20px in, level with the tiles |
| `SUPER + ALT + Arrows` | Swap places with the neighbouring tile |
| `SUPER + CTRL + Left / Right` | Shrink / grow width by 40px, repeats while held |
| `SUPER + CTRL + Up / Down` | Shrink / grow height by 40px, repeats while held |
| `SUPER + F` | Fullscreen, covers the bar |
| `SUPER + SHIFT + F` | Maximise, keeps the bar and gaps |
| `SUPER + SHIFT + V` | Toggle floating |
| `SUPER + ALT + C` | Centre a floating window |
| `SUPER + P` | Pseudotile: the window keeps its own size inside its slot |
| `SUPER + J` | Toggle split direction of the focused tile |
| `SUPER + Left drag` | Move a window with the mouse |
| `SUPER + Right drag` | Resize a window with the mouse |

Tips

- Move re-inserts the window in the layout tree, swap keeps the tree and only exchanges the two windows. Swap is what you want to reorder side by side tiles.
- Resizing a lone tile does nothing, it already fills the workspace.
- The move and swap binds work on floating windows too. Move parks a floater at the screen edge with the same 20px gap the tiles have (`gapsOut` in `hyprland.lua`).

### Caelestia shell

| Key | Does |
| --- | --- |
| `SUPER + N` | Sidebar |
| `SUPER + K` | Show all workspaces |
| `SUPER + L` | Lock (gated; fallback: hyprlock) |
| `SUPER + ALT + L` | Lock and turn off displays |
| `CTRL + ALT + Delete` | Session menu |
| `CTRL + ALT + C` | Clear notifications |
| `SUPER + ALT + M` | Spotify window (see below) |
| `SUPER + ALT + T` | Clock window (see below) |

Screenshots and recording

| Key | Does |
| --- | --- |
| `Print` | Screenshot |
| `SUPER + SHIFT + S` | Region screenshot, frozen screen (gated; fallback: hyprshot) |
| `SUPER + SHIFT + ALT + S` | Region screenshot |
| `CTRL + ALT + R` | Start / stop screen recording |
| `SUPER + ALT + R` | Record with sound |
| `SUPER + SHIFT + ALT + R` | Record a region |

Media and hardware

| Key | Does |
| --- | --- |
| `CTRL + SUPER + Space` | Play / pause |
| `CTRL + SUPER + Equal` | Next track |
| `CTRL + SUPER + Minus` | Previous track |
| `CTRL + SUPER + Backspace` | Stop |
| Media keys | Play / pause / next / previous / stop (gated; fallback: playerctl) |
| Volume keys | Volume up / down / mute, mic mute |
| Brightness keys | Screen brightness (gated; fallback: brightnessctl) |

### Look

| Key | Does |
| --- | --- |
| `SUPER + W` | Wallpaper picker |
| `SUPER + SHIFT + W` | Flip the theme between light and dark, same wallpaper |
| `SUPER + CTRL + W` | Quickshell config picker (caelestia, CaelestiaReplicate, MyOwnShell) |

### Spotify window (caelestia)

| Key or control | Does |
| --- | --- |
| `SUPER + ALT + M` | Open / close the window |
| Grid icon in the header | Switch the window between floating and tiled, remembered across opens |
| Account icon on the Library tab | Change client ID, disconnect |
| `caelestia shell spotify toggle` | Same as the keybind, from a terminal |
| `caelestia shell spotify tile` / `float` / `toggleFloating` | Change the window mode from a terminal |
| `caelestia shell spotify info` | Print address, floating state and saved preference |

### Clock window (caelestia)

| Key or control | Does |
| --- | --- |
| `SUPER + ALT + T` | Open / close the window |
| Grid icon in the header | Switch the window between floating and tiled, remembered across opens |
| `caelestia shell clock toggle` | Same as the keybind, from a terminal |
| `caelestia shell clock tile` / `float` / `toggleFloating` | Change the window mode from a terminal |
| `caelestia shell clock info` | Print address, floating state and saved preference |

---

## Neovim

Leader is Space. Format on save is on. Yanked text flashes.

### Editing basics

| Key | Mode | Does |
| --- | --- | --- |
| `Space w` | n | Save |
| `Space q` | n | Quit window |
| `Esc` | n | Clear search highlight |
| `Space f` | n, v | Format buffer, or just the selection |
| `Space l` | n | Lazy plugin manager |

### Telescope (find things)

| Key | Does |
| --- | --- |
| `Space f f` | Find files, hidden included |
| `Space f g` | Live grep across the project |
| `Space f w` | Grep the word under the cursor |
| `Space f b` | Open buffers |
| `Space f r` | Recent files |
| `Space f h` | Help tags |
| `Space f d` | Diagnostics |
| `Space f k` | Search all keymaps. Use this when you forget one. |

Inside a picker

| Key | Does |
| --- | --- |
| `Ctrl+j` / `Ctrl+k` | Next / previous result (custom) |
| `Ctrl+n` / `Ctrl+p`, arrows | Next / previous result |
| `Enter` | Open |
| `Ctrl+x` / `Ctrl+v` / `Ctrl+t` | Open in horizontal split / vertical split / new tab |
| `Ctrl+u` / `Ctrl+d` | Scroll the preview |
| `Tab` / `Shift+Tab` | Multi-select and move |
| `Ctrl+q` | Send all results to the quickfix list |
| `Alt+q` | Send the selected results to the quickfix list |
| `Ctrl+/` | Show the picker's own key help |
| `Esc` | Close the picker at once (custom) |
| `Alt+d` | In the buffers picker: delete the buffer |

### Neo-tree (file explorer)

| Key | Does |
| --- | --- |
| `Space e` | Toggle the explorer (see the clash note below) |
| `Space o` | Focus the explorer |
| `Space E` | Reveal the current file in the explorer |

Inside the tree

| Key | Does |
| --- | --- |
| `Enter` | Open |
| `s` / `S` / `t` | Open in vsplit / split / tab |
| `w` | Open with the window picker |
| `P` | Toggle preview |
| `Space` | Expand / collapse a folder |
| `Backspace` | Go up one directory |
| `.` | Make this folder the root |
| `H` | Toggle hidden files |
| `/` | Fuzzy find in the tree |
| `a` / `A` | New file (end with `/` for a folder) / new folder |
| `d` / `r` / `m` | Delete / rename / move |
| `y` / `x` / `p` | Copy / cut / paste |
| `c` | Copy to another path |
| `R` | Refresh |
| `[g` / `]g` | Previous / next git-changed file |
| `q` | Close the tree |
| `?` | Help |

### LSP (qmlls for QML, Neovim 0.11 defaults for the rest)

| Key | Does |
| --- | --- |
| `gd` / `gD` | Go to definition / declaration |
| `K` | Hover docs |
| `grn` | Rename |
| `gra` | Code action |
| `grr` | References |
| `gri` | Implementation |
| `gO` | Document symbols |
| `[d` / `]d` | Previous / next diagnostic |
| `Space e` | Line diagnostics in a float (only in LSP buffers) |
| `Ctrl+s` (insert) | Signature help |

### Completion (blink.cmp, "enter" preset)

| Key | Does |
| --- | --- |
| `Enter` | Accept the selected item |
| `Ctrl+n` / `Ctrl+p`, arrows | Next / previous item |
| `Ctrl+Space` | Open the menu, or toggle the docs |
| `Ctrl+e` | Hide the menu |
| `Tab` / `Shift+Tab` | Next / previous snippet placeholder |
| `Ctrl+b` / `Ctrl+f` | Scroll the docs |
| `Ctrl+k` | Toggle signature help |

### Treesitter selection

| Key | Mode | Does |
| --- | --- | --- |
| `Ctrl+Space` | n | Select the syntax node under the cursor |
| `Ctrl+Space` | v | Grow the selection to the parent node |
| `Backspace` | v | Shrink it back |

### Claude Code inside Neovim

| Key | Mode | Does |
| --- | --- | --- |
| `Space a c` | n | Toggle the Claude terminal (right split) |
| `Space a f` | n | Focus the Claude terminal |
| `Space a r` | n | Resume a session |
| `Space a C` | n | Continue the last session |
| `Space a b` | n | Add the current buffer to context |
| `Space a s` | v | Send the selection to Claude |
| `Space a a` | n | Accept the proposed diff |
| `Space a d` | n | Reject the proposed diff |

### Known clash

`Space e` toggles Neo-tree everywhere except in buffers with an LSP attached, where it shows line diagnostics. In QML files use `Space o` to reach the tree, or rebind one of them in `lua/plugins/lsp.lua` or `neo-tree.lua`.

---

## Kitty

No custom maps, so these are the stock ones. `kitty_mod` is Ctrl+Shift.

| Key | Does |
| --- | --- |
| `Ctrl+Shift+c` / `Ctrl+Shift+v` | Copy / paste |
| `Ctrl+Shift+Enter` | New split window |
| `Ctrl+Shift+]` / `[` | Next / previous split |
| `Ctrl+Shift+w` | Close split |
| `Ctrl+Shift+r` | Resize splits interactively |
| `Ctrl+Shift+l` | Next layout |
| `Ctrl+Shift+t` | New tab |
| `Ctrl+Shift+q` | Close tab |
| `Ctrl+Shift+Right` / `Left`, `Ctrl+Tab` | Next / previous tab |
| `Ctrl+Shift+Alt+t` | Rename the tab |
| `Ctrl+Shift+Up` / `Down` | Scroll one line |
| `Ctrl+Shift+PageUp` / `PageDown` | Scroll one page |
| `Ctrl+Shift+z` / `x` | Jump to previous / next prompt |
| `Ctrl+Shift+h` | Open scrollback in a pager |
| `Ctrl+Shift+g` | Last command's output in a pager |
| `Ctrl+Shift+/` | Search scrollback |
| `Ctrl+Shift+e` | Open a URL by hint |
| `Ctrl+Shift+p` then `f` | Insert a path by hint |
| `Ctrl+Shift+Equal` / `Minus` / `Backspace` | Font bigger / smaller / reset |
| `Ctrl+Shift+u` | Unicode input |
| `Ctrl+Shift+F2` | Edit kitty.conf |
| `Ctrl+Shift+F5` | Reload kitty.conf |
| `Ctrl+Shift+F11` | Fullscreen |

The opacity keys (`Ctrl+Shift+a` then `m` / `l`) are inert until `dynamic_background_opacity yes` is set in kitty.conf.

---

## Zsh

Oh My Zsh, emacs keymap. fzf and zoxide are not installed.

| Key | Does |
| --- | --- |
| `Esc Esc` | Prepend `sudo` to the current or last command |
| `Ctrl+r` | Search history backwards |
| `Up` / `Down` | History matching what you have typed so far |
| `Right` or `End` | Accept the grey autosuggestion |
| `Ctrl+Right` / `Alt+f` | Accept one word of the suggestion |
| `Ctrl+Left` / `Ctrl+Right` | Move by word |
| `Ctrl+a` / `Ctrl+e` | Start / end of line |
| `Ctrl+w` | Delete the word before the cursor |
| `Ctrl+u` / `Ctrl+k` | Delete to the start / end of the line |
| `Ctrl+x Ctrl+e` | Edit the command in nvim |
| `Alt+l` | Run `ls` |
| `Tab` / `Shift+Tab` | Menu completion forward / back, case-insensitive |

Aliases worth remembering

| Type | Runs |
| --- | --- |
| `vim`, `vi` | `nvim` |
| `ll`, `la` | Long listing, with hidden files |
| `..`, `...` | Up one / two directories |
| `hyprconfig`, `nvimconfig`, `zshconfig` | Open that config in nvim |
| `wallpapers` | `cd ~/Pictures/Wallpapers` |
| `x <archive>` | Extract any archive |
| `gst`, `ga`, `gaa`, `gcmsg`, `gco`, `gsw`, `gd`, `gl`, `gp`, `glog` | git status / add / add all / commit -m / checkout / switch / diff / pull / push / log |
| `pacin`, `pacupg`, `pacrem`, `pacss` | pacman install / upgrade / remove / search (also `yay*`) |
| `sc-status`, `sc-restart` | systemctl shortcuts |
| `d` then a digit | Directory stack: list, then jump |

Typing a directory name alone changes into it (`AUTO_CD`). A leading space keeps a command out of history.
