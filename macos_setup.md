# MacOS Development Environment Setup

## Zsh and dotfiles

Read through the [README](./README.md) to set up base `zsh`, `git`, and `vim` configuration

### Oh My Zsh + Powerlevel10k

Install Oh My Zsh:

```sh
# Verify: https://ohmyz.sh/#install
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Install the Fira Code Nerd Font through `brew` (scroll down to the _Brew_ section below for info in installing `brew`):

```sh
brew tap homebrew/cask-fonts
brew install font-fira-code-nerd-font
```

Then use the "Fira Code Nerd Font" as the font for your editors, terminals. This font supports the Nerd Font glyphs as well as ligatures.

Install Powerlevel10k by following https://github.com/romkatv/powerlevel10k#oh-my-zsh, which is essentially:

```sh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

Source [`zshrc.d/ohmyzsh.zsh`](./zshrc.d/ohmyzsh.zsh) to get all of the configuration, including the powerlevel10k theme config:

```sh
# ~/.zshrc
source $KDHIRA_DOTFILES/zshrc.d/ohmyzsh.zsh
```

Disable zsh's "auto cd", which is likely enabled by Oh My Zsh, by adding to your `.zshrc`:

```sh
# ~/.zshrc
unsetopt AUTO_CD
```

## iTerm2

Navigate to https://iterm2.com/ and follow the instructions to install iTerm2

_Note: there is a brew cask/formula for it https://formulae.brew.sh/cask/iterm2 but untested upgrading the formula while using the application_

## Warp

Navigate to https://warp.dev and follow the instructions to install Warp

## Visual Studio Code

Navigate to https://code.visualstudio.com/ and follow the instructions to install Visual Studio Code

_Note: there is a brew cask/formula for it https://formulae.brew.sh/cask/visual-studio-code, but has not been tested yet_

## Docker

Navigate to https://docs.docker.com/desktop/mac/install/ and follow instructions

## Brew

```sh
# Verify: https://brew.sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Useful software installable through `brew`:

```sh
brew install git
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

### nvm

Install with:

```sh
brew install nvm
```

To enable, follow the instructions for the `brew postinstall`, or alternatively source [`zshrc.d/nvm.sh`](./zshrc.d/nvm.sh):

```sh
# ~/.zshrc
source $KDHIRA_DOTFILES/zshrc.d/nvm.sh
```

### fzf

_fzf allows for a better fuzzy search in terminal._

> For more info, visit https://github.com/junegunn/fzf

Install with:

```sh
brew install fzf
```

Enable `fzf` through script source:

```sh
# ~/.zshrc
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
```

### starship

_Starship provides a configuration framework for terminal prompt._

> For more info, visit https://starship.rs/

Install with:

```sh
brew install starship
```

Enable the prompt through the following `eval`:

```sh
# ~/.zshrc
export STARSHIP_CONFIG=$KDHIRA_DOTFILES/starship/starship.toml
eval "$(starship init zsh)"
```

Edit [`starship.toml`](./starship/starship.toml) to configure the prompt

### rectangle

_Rectangle is a window management tool for MacOS._

> For more info, visit https://rectangleapp.com

Install with:

```sh
# https://formulae.brew.sh/cask/rectangle
brew install --cask rectangle
```

Keyboard shortcuts:

- `Ctrl + Opt + Arrow` - split window in current screen
- `Ctrl + Opt + Cmd + Left/Right` - move window between screens
- `Ctrl + Opt + Enter` - maximise window in current screen (not full screen)
- `Ctrl + Opt + Backspace` - restore window size
- `Ctrl + Opt + C` - centre window
