# dotfiles

GNU stow packages. Each top-level directory mirrors the path it links into `$HOME`.

## Install

```sh
sudo pacman -S --needed stow
git clone <this repo> ~/dotfiles
cd ~/dotfiles
stow -t ~ zsh bash git hypr nvim quickshell kitty wofi theme qt6ct htop misc
```

## Docs

- `docs/keybinds.md` — every keybind in daily use (Hyprland, caelestia, Neovim, kitty, zsh). `~/notes` links to `docs/`.

## Not tracked here

- **oh-my-zsh** — `.zshrc` loads two custom plugins that are git clones, not dotfiles:

  ```sh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  ```

- **caelestia shell** — `quickshell/.config/quickshell/caelestia` is a symlink
  to `/home/slime/github-repos/shell`, an upstream clone that needs building.
  Install its dependencies from its README ("Manual installation"), plus
  `cmake`, `ninja` and the separate `caelestia-cli` for the `caelestia`
  command, then:

  ```sh
  git clone https://github.com/caelestia-dots/shell.git ~/github-repos/shell
  cd ~/github-repos/shell
  cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/
  cmake --build build
  sudo cmake --install build
  ```

  The link is absolute, so under a username other than `slime`, repoint it
  after stowing: `ln -sfn ~/github-repos/shell ~/.config/quickshell/caelestia`.

- **nvm** — `.bashrc` and `.zshrc` source `/usr/share/nvm/init-nvm.sh` (`pacman -S nvm`).
- **`start-hyprland`** — shipped by the `hyprland` package, not a local script.
- **Generated theme output** — see `.gitignore`. The sources live in
  `theme/.config/theme/templates/`; matugen renders them into each app's real
  config path on every wallpaper change, so those paths stay unstowed.
