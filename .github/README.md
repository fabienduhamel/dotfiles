# Dev setup

Contains mandatory dotfiles and other stuff for personal dev :)

## How to

```sh
chezmoi init --apply https://github.com/fabienduhamel/dotfiles
```

[chezmoi documentation](https://www.chezmoi.io/user-guide/command-overview/)

## ZSH installation

Follow:

- [https://ohmyz.sh/#install](https://ohmyz.sh/#install)
- [https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#installation](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#installation)

### Fonts

Download [MesloLG Nerd Font](https://www.nerdfonts.com/font-downloads).

### Theme

Import themes from `iterm2/` folder.

### Settings

Import settings from `iterm2/` folder.

## Brew packages

```sh
# dev
brew install bat curl diff-so-fancy fzf gh jq yq ripgrep telnet tldr wget node yarn git-interactive-rebase-tool prettyping ack ag btop atuin fx tabiew eza zoxide fd hub
# others
brew install WebPQuickLook borgbackup exiftool ffmpeg imagemagick rsync
```

## Others

```sh
# zsh-autosuggestions (optional)
# https://github.com/zsh-users/zsh-autosuggestions
brew install zsh-autosuggestions
```

[BrightIntosh](https://www.brightintosh.de/) app for XDR brightness on MacOS.
