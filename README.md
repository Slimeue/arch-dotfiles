# dotfiles

GNU stow packages. Each top-level directory mirrors the path it links into `$HOME`.

## Install

```sh
sudo pacman -S --needed stow
git clone <this repo> ~/dotfiles
cd ~/dotfiles
stow -t ~ zsh bash git hypr nvim quickshell kitty wofi theme qt6ct htop misc
```

## Not tracked here

- **oh-my-zsh** — `.zshrc` loads two custom plugins that are git clones, not dotfiles:

  ```sh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  ```

- **nvm** — `.bashrc` sources `/usr/share/nvm/init-nvm.sh` (`pacman -S nvm`).
- **`start-hyprland`** — shipped by the `hyprland` package, not a local script.
- **Generated theme output** — see `.gitignore`. The sources live in
  `theme/.config/theme/templates/`; matugen renders them into each app's real
  config path on every wallpaper change, so those paths stay unstowed.
