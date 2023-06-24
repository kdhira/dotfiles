#!/bin/zsh

###############################################################################
# KDHIRA DOTFILES ZSHRC
# Author: Kevin Hira
#
# Environment Variables (set in ~/.zshenv):
# > Required
#   - KDHIRA_DOTFILES: Directory to dotfiles repo clone
# > Optional
#   - KDHIRA_PROMPT_STRATEGY: Which PS1 prompt engine to use (pl10k, starship)
#   - STARSHIP_CONFIG: Path to sharship config
#       (default $KDHIRA_DOTFILES/starship/starship.toml)

###############################################################################

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source $KDHIRA_DOTFILES/zshrc.d/homebrew.sh

if [[ $TERM_PROGRAM == 'WarpTerminal' ]]; then
    KDHIRA_PROMPT_STRATEGY=${KDHIRA_PROMPT_WARP_STRATEGY:-pl10k}
fi

if [[ $TERM_PROGRAM == 'iTerm.app' ]]; then
    source $KDHIRA_DOTFILES/zshrc.d/iterm2.sh
    KDHIRA_PROMPT_STRATEGY=${KDHIRA_PROMPT_ITERM_STRATEGY:-pl10k}
fi

# Depends on:
#   - KDHIRA_PROMPT_STRATEGY
source $KDHIRA_DOTFILES/zshrc.d/ohmyzsh.zsh

# fzf, not supported for WarpTerminal
if [[ $TERM_PROGRAM == 'iTerm.app' || $TERM_PROGRAM == 'vscode' ]]; then
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

if [[ $KDHIRA_PROMPT_STRATEGY == 'starship' ]]; then
    export STARSHIP_CONFIG=${STARSHIP_CONFIG:-$KDHIRA_DOTFILES/starship/starship.toml}
    eval "$(starship init zsh)"
fi

source $KDHIRA_DOTFILES/zshrc.d/nvm.sh
source $KDHIRA_DOTFILES/zshrc.d/env.sh
source $KDHIRA_DOTFILES/zshrc.d/alias.sh

autoload -U +X bashcompinit && bashcompinit

# Terraform autocomplete
# `terraform -install-autocomplete`
test -f /usr/local/bin/terraform && complete -o nospace -C /usr/local/bin/terraform terraform

unsetopt AUTO_CD

# Per-machine customisations
if [ -f ~/.zshrc-user ]; then
    source ~/.zshrc-user
fi
