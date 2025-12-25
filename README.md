# dotfiles

This is the repository to store configuration for some of the software/programs I use that don't have their own natural configuration sync/version-control capabilities.

## Setup (Quickstart)

### 1) Set `KDHIRA_DOTFILES`

Set `KDHIRA_DOTFILES` in `~/.zshenv` so your shell can find this repo reliably (especially after symlinking `~/.zshrc`):

```sh
# ~/.zshenv
export KDHIRA_DOTFILES=/path/to/dotfiles
```

### 2) Symlink configs into `$HOME`

```sh
mv ~/.zshrc{,.old}
ln -s $KDHIRA_DOTFILES/.zshrc ~/.zshrc
```

This `KDHIRA_DOTFILES` variable will be used elsewhere to reference files in the repo.

## macOS Setup

### Homebrew

Install Homebrew:

```sh
# Verify: https://brew.sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Note: Apple Silicon uses `/opt/homebrew` by default. The script `zshrc.d/homebrew.sh` handles shell init on both Intel and Apple Silicon.

If you need it manually:

```sh
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Packages

```sh
brew install git
brew install zsh
brew install fzf
brew install fnm
brew install oh-my-posh

brew install htop
brew install tree
brew install watch
brew install vim
brew install python
brew install rbenv
brew install swaks
brew install httpie
brew install jq
brew install kubectl minikube
brew install awscli aws-shell
brew install terraform
```

### Fonts

Install the Fira Code Nerd Font:

```sh
brew tap homebrew/cask-fonts
brew install font-fira-code-nerd-font
```

Then use "Fira Code Nerd Font" as the font for your terminal/editor.

### Apps

Install via brew casks (or download directly if you prefer):

```sh
brew install --cask iterm2
brew install --cask warp
brew install --cask visual-studio-code
brew install --cask docker
brew install --cask rectangle
```

Rectangle keyboard shortcuts:

- `Ctrl + Opt + Arrow` - split window in current screen
- `Ctrl + Opt + Cmd + Left/Right` - move window between screens
- `Ctrl + Opt + Enter` - maximise window in current screen (not full screen)
- `Ctrl + Opt + Backspace` - restore window size
- `Ctrl + Opt + C` - centre window

## Shell (zsh)

The default `~/.zshrc` in this repo uses:

- `zinit` for plugin management (`zshrc.d/zinit.zsh`)
- `oh-my-posh` for prompt theming (`oh-my-posh/omp.toml`)

The `zshrc.d/` folder contains additional scripts that are sourced by `.zshrc`.

## Git Configuration

The [`.gitconfig`](./.gitconfig) file has my configuration and aliases for git, install by symlinking to your HOME directory:

```sh
ln -s $KDHIRA_DOTFILES/.gitconfig ~/.gitconfig
ln -s $KDHIRA_DOTFILES/.gitexcludes ~/.gitexcludes
```

This file has an include to `~/.gitconfig-user` which can hold the per-machine overrides. The `.gitconfig` has the `user.name` configuration set so, for me, only `user.email` should need to be set, but other things can be overridden/set here too (including `user.name`):

```sh
# Use "-f ~/.gitconfig-user" param to set config file to write to, eg:
git config -f ~/.gitconfig-user user.email "<email>"

# To override user.name from .gitconfig
git config -f ~/.gitconfig-user user.name "<name>"
```

## Vim Configuration

The [`.vimrc`](./.vimrc) file has my vim profile. Consume by symlinking into your HOME directory:

```sh
ln -s $KDHIRA_DOTFILES/.vimrc ~/.vimrc
```

After this, on first boot of vim you might be automatically kicked after it downloads some files for `VimPlug`. If this happens, open `vim` again and run the commands

```sh
:PlugInstall

# :PlugUpdate is useful for updating VimPlug plugins
# :PlugUpgrade is useful for updating the VimPlug software itself
```
