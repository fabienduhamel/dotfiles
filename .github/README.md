# Dev setup

Contains mandatory dotfiles and other stuff for personal dev :)

## Setup

### MacOS

```sh
# brew install (https://brew.sh/)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# iterm2 (https://formulae.brew.sh/cask/iterm2)
brew install --cask iterm2
# or WezTerm
brew install --cask wezterm

# dev
xargs brew install < brew-apps.txt

# uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# --- others ---
xargs brew install < brew-extras.txt

# zsh-autosuggestions (optional)
# https://github.com/zsh-users/zsh-autosuggestions
brew install zsh-autosuggestions
```

### Linux server

```sh
xargs sudo apt install < apt-apps.txt

sudo npm install -g diff-so-fancy

# uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# neovim
# follow nvim.appimage installation here: https://github.com/neovim/neovim-releases/releases
sudo apt install fuse
curl -L -XGET https://github.com/neovim/neovim-releases/releases/latest/download/nvim.appimage -o nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim
sudo chmod 755 /usr/local/bin/nvim

# cargo
sudo apt-get install protobuf-compiler
curl https://sh.rustup.rs -sSf | sh

cargo install atuin eza
```

### ZSH

Follow:

- [https://ohmyz.sh/#install](https://ohmyz.sh/#install)
- [https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#installation](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#installation)

- Add plugins:

```sh
git clone https://github.com/jkavan/terragrunt-oh-my-zsh-plugin ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/terragrunt
```

### Fonts

Download [MesloLGL Nerd Font](https://www.nerdfonts.com/font-downloads).

### iTerm2

- Import themes from `iterm2/` folder
- Import settings from `iterm2/` folder

### Lazyvim

Follow [Lazyvim installation](https://www.lazyvim.org/installation).

### Window management

1. Install [skhd](https://github.com/koekeishiya/skhd)
2. Install [Rectangle](https://rectangleapp.com/)
3. Install [Yabai](https://github.com/koekeishiya/yabai)

Optional (for window borders): 4. Install [JankyBorders](https://github.com/FelixKratz/JankyBorders)

Setup your wallpaper!

### chezmoi

Create `~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
  email = "<email>"
```

```sh
# MacOS (installed with brew)
chezmoi init --apply https://github.com/fabienduhamel/dotfiles
# Linux (not available with apt)
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply fabienduhamel
```

[chezmoi documentation](https://www.chezmoi.io/user-guide/command-overview/)

## Desktop apps

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [VSCode](https://code.visualstudio.com/)
- [Raycast](https://www.raycast.com/) or [Alfred](https://www.alfredapp.com/)
- [Rectangle](https://rectangleapp.com/) - window management (included in Raycast)
- [Amphetamine](https://apps.apple.com/fr/app/amphetamine/id937984704?mt=12)
- [Mos](https://mos.caldis.me/) - smooth mouse scrolling
- [AltTab](https://alt-tab-macos.netlify.app/)
- [BetterDisplay](https://github.com/waydabber/BetterDisplay)
- [Obsidian](https://obsidian.md/)
- [Stats](https://github.com/exelban/stats)
- [Itsycal](https://www.mowglii.com/itsycal/)
- [Azayaka](https://github.com/Mnpn/Azayaka) - screen capture
