#!/usr/bin/env zsh

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

# Homebrew init
# LOADS:
#   HOMEBREW_PREFIX
source $KDHIRA_DOTFILES/zshrc.d/homebrew.sh

KDHIRA_PROMPT_STRATEGY=${KDHIRA_PROMPT_WARP_STRATEGY:-pl10k}

if [[ $TERM_PROGRAM == 'iTerm.app' ]]; then
    [ -f "$HOME/.iterm2_shell_integration.zsh" ] && source "$HOME/.iterm2_shell_integration.zsh"
fi

# Depends on:
#   - KDHIRA_PROMPT_STRATEGY
KDHIRA_ZSH_PLUGIN_MANGER=${KDHIRA_ZSH_PLUGIN_MANGER:-zinit}
[ "$KDHIRA_ZSH_PLUGIN_MANGER" = "zinit" ] && source $KDHIRA_DOTFILES/zshrc.d/zinit.zsh
[ "$KDHIRA_ZSH_PLUGIN_MANGER" = "ohmyzsh" ] && source $KDHIRA_DOTFILES/zshrc.d/ohmyzsh.zsh

# fzf, not supported for WarpTerminal
if [[ $TERM_PROGRAM != 'WarpTerminal' ]]; then
    command -v fzf &>/dev/null || brew install fzf
    eval "$(fzf --zsh)"

    # fzf catppuccin theme
    # https://github.com/catppuccin/fzf
    export FZF_DEFAULT_OPTS=" \
    --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
    --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
    --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
fi

if [[ $KDHIRA_PROMPT_STRATEGY == 'starship' ]]; then
    command -v starship &>/dev/null || brew install starship
    export STARSHIP_CONFIG=${STARSHIP_CONFIG:-$KDHIRA_DOTFILES/starship/starship.toml}
    eval "$(starship init zsh)"
fi

source $KDHIRA_DOTFILES/zshrc.d/env.sh
source $KDHIRA_DOTFILES/zshrc.d/alias.sh

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && source "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# Per-machine customisations
if [ -f ~/.zshrc-user ]; then
    source ~/.zshrc-user
fi

unsetopt AUTO_CD
autoload -U compinit && compinit
autoload -U +X bashcompinit && bashcompinit

if type zinit &>/dev/null; then
    zinit cdreplay -q
fi
