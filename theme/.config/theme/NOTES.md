# Wallpaper Theme Manager — what was built and why

A theme manager that derives a colour palette from your current wallpaper and
pushes it into every themable app on your system. Change the wallpaper, and
kitty, the quickshell bar, wofi, dunst, Hyprland's borders, hyprlauncher, GTK
apps and Qt apps follow.

Built on **matugen 4.2** (Google's Material You algorithm), running in **dark
mode by default with a light/dark toggle** on `SUPER + SHIFT + W`.

---

## 1. How it works

```
  SUPER+W  ──►  wallpaper-picker.sh ──┐
  login    ──►  wallpaper-restore.sh ─┼──►  wallpaper-apply.sh
  manual   ──►  wallpaper-apply.sh ───┘            │
                                                   │ 1. awww sets the wallpaper
                                                   │ 2. path → ~/.cache/current-wallpaper
                                                   ▼
                                          theme-apply.sh
                                                   │
                        ┌──────────────────────────┼──────────────────────────┐
                        ▼                          ▼                          ▼
                  read mode file           matugen extracts            render 10 templates
                 (dark | light)          palette from image           into real config paths
                                                                              │
                                                   ┌──────────────────────────┘
                                                   ▼
                                          reload running apps
                                  kitty · dunst · Hyprland (live)
                        quickshell watches palette.json and needs no reload
```

**The key design decision** is that `wallpaper-apply.sh` is the single
integration point. All three paths that change your wallpaper already routed
through it, so hooking theming in there means **the theme can never drift out
of sync with the wallpaper** — including after a reboot, because
`wallpaper-restore.sh` replays the last wallpaper through the same script.

### Why matugen rather than pywal/wallust

pywal-style tools give you 16 colours pulled from the image and leave contrast
to luck — you get a bar where the clock is unreadable half the time. matugen
produces a *semantic* Material You palette: `surface` always pairs with
`on_surface`, `primary` with `on_primary`, and those pairs are contrast-checked
by construction. Templates reference roles by meaning, so legibility is
structural rather than accidental.

Measured on the current wallpaper, every foreground/background pair used by
these templates passes WCAG AA (≥4.5:1) **in both modes**:

| | dark | light |
|---|---|---|
| `on_surface` / `surface` | 14.37 | 16.38 |
| `on_surface_variant` / `surface` | 10.93 | 8.90 |
| `primary` / `surface` | 10.93 | 6.16 |
| `on_primary` / `primary` | 7.75 | 6.46 |
| worst ANSI colour vs terminal bg | 11.33 | 6.43 |

---

## 2. Folder structure

```
~/.config/theme/                      ← everything new lives here
│
├── NOTES.md                          ← this file
├── config.toml                       ← matugen config: 6 ANSI custom_colors,
│                                       one [templates.*] block per output file
├── theme-apply.sh          (exec)    ← orchestrator: resolve mode + wallpaper,
│                                       run matugen, repair qt6ct, reload apps
├── theme-toggle.sh         (exec)    ← one-line wrapper: theme-apply.sh --toggle
│
├── templates/                        ← EDIT THESE to change the design.
│   │                                   Never edit the generated files — they are
│   │                                   overwritten on every wallpaper change.
│   ├── kitty-colors.conf             → ~/.config/kitty/colors.conf
│   ├── wofi-style.css                → ~/.config/wofi/style.css
│   ├── dunstrc                       → ~/.config/dunst/dunstrc
│   ├── hypr-colors.lua               → ~/.config/hypr/colors.lua
│   ├── hyprtoolkit.conf              → ~/.config/hypr/hyprtoolkit.conf
│   ├── gtk.css                       → ~/.config/gtk-3.0/gtk.css
│   │                                 → ~/.config/gtk-4.0/gtk.css  (one template, two outputs)
│   ├── qt6ct-colors.conf             → ~/.config/qt6ct/colors/wallpaper.conf
│   └── palette.json                  → ~/.config/theme/state/palette.json
│                                       (also read live by the quickshell bar)
│
├── state/
│   ├── mode                          ← "dark" or "light". Persists across wallpaper
│   │                                   changes, so a new wallpaper won't flip you back.
│   └── palette.json                  ← machine-readable current palette. jq-friendly;
│                                       theme-apply.sh reads it to drive hyprctl,
│                                       the quickshell bar watches it for live
│                                       recolouring, and you can use it in scripts.
│
└── backups/                          ← untouched copies of every modified file,
    ├── dunst_dunstrc                   taken before any change was made
    ├── hypr_hyprland.lua
    ├── hypr_scripts_wallpaper-apply.sh
    ├── kitty_kitty.conf
    └── wofi_style.css
```

### Files generated outside `~/.config/theme/`

Overwritten on every wallpaper change; each carries an "AUTOGENERATED" banner
naming its template (except the qt6ct one — see §5).

| Generated file | Purpose |
|---|---|
| `~/.config/kitty/colors.conf` | terminal bg/fg/cursor/selection/tabs + ANSI 0–15 |
| `~/.config/wofi/style.css` | launcher colours (your original layout, kept) |
| `~/.config/dunst/dunstrc` | full notification config (dunst has no `include`) |
| `~/.config/hypr/colors.lua` | border gradient, inactive border, shadow tint |
| `~/.config/hypr/hyprtoolkit.conf` | hyprlauncher's palette |
| `~/.config/gtk-3.0/gtk.css`, `~/.config/gtk-4.0/gtk.css` | GTK named-colour overrides |
| `~/.config/qt6ct/colors/wallpaper.conf` | Qt6 palette |

---

## 3. Changes made to your existing files

### `~/.config/hypr/scripts/wallpaper-apply.sh` — appended
Calls `theme-apply.sh` after the wallpaper is set and the state file written.
Guarded with `|| true`, so **a theming failure can never leave you with no
wallpaper** — the wallpaper matters, the theme is cosmetic.

### `~/.config/kitty/kitty.conf` — appended
One line: `include colors.conf`, at the very end so it wins over anything above.
It deliberately does *not* set `background_opacity`, so your manual
`background_opacity 0.5` survives every re-theme.

### `~/.config/hypr/hyprland.lua` — five edits
1. **`hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")`** — without this, Qt apps never
   consult qt6ct.
2. **A `colors` loader** before `hl.config`. Uses `dofile` with an absolute path
   rather than `require()`, because Hyprland's Lua `package.path` does not
   necessarily include `~/.config/hypr`. Wrapped in `pcall` with your original
   colours as fallback — **if `colors.lua` is missing or malformed you get the
   old teal/green borders, not a config that refuses to start.**
3. **`general.col`** reads `colors.active_border` / `colors.inactive_border`
   instead of the hard-coded `rgba(33ccffee)` / `rgba(00ff99ee)`.
4. **`decoration.shadow.color`** reads `colors.shadow_color`.
5. **`SUPER + SHIFT + W`** bound to the light/dark toggle, next to your existing
   `SUPER + W` wallpaper picker.

Validated with `luac -p`.

### `~/.config/qt6ct/qt6ct.conf` — created
Written once, not regenerated, so qt6ct GUI settings survive. Two settings
matter: `custom_palette=true` (without it `color_scheme_path` is ignored
entirely) and `style=Fusion`.

### Packages required
`matugen` and `qt6ct`, both from `extra` — no AUR needed:
```bash
sudo pacman -S --needed matugen qt6ct
```

---

## 4. Four things that do not work the obvious way

These cost real debugging time. They are written down so they do not have to be
rediscovered.

### 4.1 `matugen` aborts under automation without `--prefer`

When an image yields several candidate source colours, matugen 4.x asks which
to use — and when it cannot detect a terminal it **errors out** instead:

```
Multiple source colors found, no preference was inputted, and a terminal
was not detected. Use --prefer=PREFERENCE ...
```

Run from `wallpaper-apply.sh` there is no terminal, so without `--prefer` the
theme would simply never regenerate, silently. `theme-apply.sh` passes
`--prefer saturation` (most vivid candidate → most distinctive accent).
Override per run with `THEME_PREFER=darkness theme-apply.sh`; valid values are
`darkness`, `lightness`, `saturation`, `less-saturation`, `value`,
`closest-to-fallback`.

It also passes `--fallback-color` so near-black/near-white wallpapers degrade
instead of aborting.

### 4.2 `hyprctl keyword` does not work with a Lua config

Your Hyprland config is Lua, and Hyprland rejects `keyword` against it:

```
keyword can't work with non-legacy parsers. Use eval.
```

The first version of this script used `hyprctl --batch keyword ...` and
reported success while changing nothing — the error was being swallowed by
`>/dev/null`. It now pushes a partial `hl.config` through `hyprctl eval` and
**checks that the reply is `ok`**, printing the error otherwise.

### 4.3 Separate `bright_*` custom colours collapse onto their base

The intuitive way to get ANSI 9–14 is to declare `bright_red`, `bright_green`…
as extra `custom_colors`. It does not work: matugen's harmonisation pulls a hue
and its brighter sibling to nearly the same result. Measured:

```
green  #95d5a7      bright_green  #95d5a8     ← one step apart
red    #ffb0ce      bright_red    #feb0d2
```

So `config.toml` declares only the **six** base hues, and the kitty template
derives the brights with `| to_color | lighten: 6.0`. That guarantees
separation (measured 1.10–1.48 contrast ratio between each base and its
bright) while staying small enough not to wash out in light mode.

### 4.4 Opening the qt6ct GUI destroys its own config

qt6ct saves `qt6ct.conf` through QSettings on exit. That rewrite **strips
comments** (turning them into URL-encoded junk in a bogus `[General]` section)
and **resets `color_scheme_path` to a stock scheme**, silently unthemeing every
Qt app. This happened once during setup.

Two defences:
- `templates/qt6ct-colors.conf` contains **no comments at all** — QSettings'
  INI parser is not reliable with them. That is why the generated
  `wallpaper.conf` is the one file without an AUTOGENERATED banner.
- `theme-apply.sh` **re-asserts `color_scheme_path` and `custom_palette=true`
  on every run** and logs `repaired qt6ct.conf` when it had to act. So opening
  the qt6ct GUI costs you one wallpaper change to recover, not a silent
  permanent breakage.

---

## 5. How each app gets reloaded

| App | Mechanism | Instant? |
|---|---|---|
| **kitty** | `SIGUSR1` → re-reads config in place | yes, scrollback kept |
| **quickshell** | none needed — it watches `state/palette.json` itself | yes |
| **dunst** | `dunstctl reload`, falling back to `pkill` (D-Bus activated, respawns) | yes |
| **Hyprland** | `hyprctl eval` with a partial `hl.config` | yes, no config-reload flash |
| **wofi** | nothing needed — reads its CSS fresh on every launch | yes |
| **hyprlauncher** | nothing needed — reads `hyprtoolkit.conf` on launch | yes |
| **GTK apps** | none available — GTK reads CSS at startup only | on app restart |
| **Qt apps** | none available — Qt reads the palette at startup only | on app restart |

The quickshell bar is the one app the script does not have to signal. It holds
a `FileView` on `state/palette.json` with `watchChanges: true`, so the write
that matugen already performs is itself the reload. That is also why there is
no `[templates.quickshell]` block in `config.toml`: the bar consumes the
palette rather than being rendered from it.

waybar and its leftovers are gone: `~/.config/waybar/`, its template, its
backup, and `~/auto-reload.sh` (the inotify watcher that SIGUSR2'd it on
stylesheet writes) have all been removed.

---

## 6. Usage

```bash
# Normal use — nothing to run. Pick a wallpaper with SUPER+W; everything follows.

# Toggle light/dark, keeping the current wallpaper
SUPER + SHIFT + W
~/.config/theme/theme-toggle.sh

# Force a mode
~/.config/theme/theme-apply.sh --light
~/.config/theme/theme-apply.sh --dark

# Re-theme from the current wallpaper (e.g. after editing a template)
~/.config/theme/theme-apply.sh

# Theme from a specific image without changing the wallpaper
~/.config/theme/theme-apply.sh ~/Pictures/Wallpapers/makima.jpg

# Pick the source colour differently
THEME_PREFER=darkness ~/.config/theme/theme-apply.sh

# Read the current palette in your own scripts
jq -r .primary ~/.config/theme/state/palette.json
```

### Changing the design

Edit the relevant file in `templates/`, then run `theme-apply.sh`. Available
roles are listed in `state/palette.json`; matugen also exposes
`primary_container`, `secondary`, `tertiary`, `error_container`, the full
`surface_container_*` ramp, `outline`, `inverse_surface`, `shadow`, plus the six
custom ANSI colours. Filters like `| to_color | lighten: N` work in any
template (`matugen color hex '#000' --filter-docs-html` lists them all).

---

## 7. What is verified, and what is not

**Verified by screenshot on this machine:**
- quickshell bar — active workspace pill in `primary` with `on_primary` text;
  clock in `primary` bold on a `surface_container_high` pill; verified in both
  modes by toggling with the bar running, which recoloured it live
- dunst — normal notification on `surface_container_high` with the `primary`
  frame; critical on `error_container` with the `error` frame
- Qt apps — qt6ct's own GUI renders fully themed from the generated scheme
- Hyprland — `hyprctl getoption` confirms the gradient changes from
  `ee33ccff ee00ff99` to the wallpaper's `ee8bd0f0 eec6c2ea` after a run
- light/dark toggle, and the mode persisting across wallpaper changes

**Not verified — needs your eyes:**
- **hyprlauncher.** It renders no surface when launched from a non-interactive
  shell, so it could not be screenshotted. The `hyprtoolkit.conf` key names
  (`background`, `base`, `alternate_base`, `text`, `bright_text`, `link_text`,
  `accent`, `accent_secondary`) were read out of `libhyprtoolkit.so`'s symbol
  table, and the flat (section-less) layout is inferred from the absence of any
  `palette:`-prefixed strings in that binary. It causes no errors, but whether
  it takes effect is unconfirmed. **Press `SUPER + R` and see.**

---

## 8. Known limits — stated plainly

- **Dolphin is NOT themed, and cannot be without another package.** This was
  tested three ways and all three failed: qt6ct's palette, a full
  `~/.config/kdeglobals` colour scheme, and a named `.colors` scheme in
  `~/.local/share/color-schemes/`. Dolphin is a KDE Frameworks app; outside a
  Plasma session nothing bridges those colours onto its `QPalette`, so it falls
  back to built-in light defaults regardless of `QT_QPA_PLATFORMTHEME`.
  The missing piece is **`plasma-integration`** (in `extra`, not installed),
  which pulls in Plasma libraries. Generic Qt6 apps *are* themed correctly —
  this limit is specific to KDE Frameworks apps. All probe files written during
  that investigation were removed.
- **GTK theming is partial.** `@define-color` overrides are honoured
  inconsistently. nm-applet and stock GTK dialogs pick them up; LibreWolf's
  content area and anything using libadwaita's hard-coded recolouring will
  ignore some or all of it. This shifts GTK chrome toward the wallpaper — it is
  not a full GTK theme.
- **Kvantum was not used.** Its themes are SVG-based; what it adds over a
  palette is widget *geometry*, which does not vary with a wallpaper.
- **GTK and Qt apps need a restart** to pick up new colours.
- **`~/.config/hypr/hyprpaper.conf` is vestigial** — `awww` is your actual
  wallpaper daemon and hyprpaper is not running. Left in place, harmless.
- **dunst's `corner_radius` stays at 0**, matching your original config, even
  though Hyprland uses `rounding = 10`. One-line change in `templates/dunstrc`
  if you want them to agree.

---

## 9. Reverting

```bash
cp ~/.config/theme/backups/hypr_hyprland.lua               ~/.config/hypr/hyprland.lua
cp ~/.config/theme/backups/kitty_kitty.conf                ~/.config/kitty/kitty.conf
cp ~/.config/theme/backups/wofi_style.css                  ~/.config/wofi/style.css
cp ~/.config/theme/backups/dunst_dunstrc                    ~/.config/dunst/dunstrc
cp ~/.config/theme/backups/hypr_scripts_wallpaper-apply.sh ~/.config/hypr/scripts/wallpaper-apply.sh
rm -f ~/.config/kitty/colors.conf ~/.config/hypr/colors.lua \
      ~/.config/hypr/hyprtoolkit.conf ~/.config/gtk-3.0/gtk.css ~/.config/gtk-4.0/gtk.css
rm -rf ~/.config/qt6ct
hyprctl reload
```
