# Dev setup

Contains mandatory dotfiles and other stuff for personal dev :)

## Setup

### MacOS

```sh
# brew install (https://brew.sh/)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# iterm2 (https://formulae.brew.sh/cask/iterm2)
brew install --cask iterm2

# dev
brew install \
  zsh \
  coreutils \
  neovim \
  bat \
  curl \
  diff-so-fancy \
  fzf \
  gh \
  jq \
  yq \
  ripgrep \
  telnet \
  tldr \
  wget \
  node \
  yarn \
  git-interactive-rebase-tool \
  prettyping \
  ack \
  ag \
  btop \
  atuin \
  fx \
  tabiew \
  eza \
  zoxide \
  fd \
  hub \
  ffurrer2/tap/semver \
  chezmoi

# --- others ---
brew install WebPQuickLook borgbackup exiftool ffmpeg imagemagick rsync jdupes

# zsh-autosuggestions (optional)
# https://github.com/zsh-users/zsh-autosuggestions
brew install zsh-autosuggestions
```

### Linux server

```sh
sudo apt install \
  zsh \
  bat \
  curl \
  fzf \
  gh \
  jq \
  yq \
  ripgrep \
  telnet \
  tldr \
  wget \
  nodejs \
  npm \
  prettyping \
  ack \
  silversearcher-ag \
  btop \
  zoxide \
  fd-find \
  hub \
  python3-semver

sudo npm install -g diff-so-fancy

# neovim
# follow nvim.appimage installation here: https://github.com/neovim/neovim-releases/releases
sudo apt install fuse
curl -XGET https://github.com/neovim/neovim-releases/releases/latest/download/nvim.appimage -o nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim

# cargo
sudo apt-get install protobuf-compiler
curl https://sh.rustup.rs -sSf | sh

cargo install atuin eza
```

### ZSH

Follow:

- [https://ohmyz.sh/#install](https://ohmyz.sh/#install)
- [https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#installation](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#installation)

### Fonts

Download [MesloLG Nerd Font](https://www.nerdfonts.com/font-downloads).

### iterm2

- Import themes from `iterm2/` folder
- Import settings from `iterm2/` folder

### Lazyvim

Follow [Lazyvim installation](https://www.lazyvim.org/installation).

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

## Apps

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [VSCode](https://code.visualstudio.com/)
- [Alfred](https://www.alfredapp.com/)
- [Rectangle](https://rectangleapp.com/) - window management
- [BrightIntosh](https://www.brightintosh.de/) - XDR brightness on MacOS
- [Amphetamine](https://apps.apple.com/fr/app/amphetamine/id937984704?mt=12)
- [Mos](https://mos.caldis.me/) - smooth mouse scrolling
- [AltTab](https://alt-tab-macos.netlify.app/)
