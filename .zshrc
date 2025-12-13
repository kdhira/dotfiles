#!/usr/bin/env zsh

###############################################################################
# KDHIRA DOTFILES ZSHRC
# Author: Kevin Hira
#
# Environment Variables (set in ~/.zshenv):
# > Required
#   - KDHIRA_DOTFILES: Directory to dotfiles repo clone
# > Optional
#   - KDHIRA_PROMPT_STRATEGY: Which PS1 prompt engine to use (omp, starship)
#   - STARSHIP_CONFIG: Path to sharship config
#       (default $KDHIRA_DOTFILES/starship/starship.toml)

###############################################################################

KDHIRA_PROMPT_STRATEGY=${KDHIRA_PROMPT_STRATEGY:-omp}
KDHIRA_ZSH_PLUGIN_MANAGER=${KDHIRA_ZSH_PLUGIN_MANAGER:-zinit}

# Homebrew init
# LOADS:
#   HOMEBREW_PREFIX
source $KDHIRA_DOTFILES/zshrc.d/homebrew.sh

if [[ $TERM_PROGRAM == 'iTerm.app' ]]; then
    [ -f "$HOME/.iterm2_shell_integration.zsh" ] && source "$HOME/.iterm2_shell_integration.zsh"
fi

[ "$KDHIRA_ZSH_PLUGIN_MANAGER" = "zinit" ] && source $KDHIRA_DOTFILES/zshrc.d/zinit.zsh
[ "$KDHIRA_ZSH_PLUGIN_MANAGER" = "ohmyzsh" ] && source $KDHIRA_DOTFILES/zshrc.d/ohmyzsh.zsh

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

if [[ $KDHIRA_PROMPT_STRATEGY == 'omp' ]]; then
    command -v oh-my-posh &>/dev/null || brew install oh-my-posh
    eval "$(oh-my-posh init zsh --config $KDHIRA_DOTFILES/oh-my-posh/omp.toml)"
fi

source $KDHIRA_DOTFILES/zshrc.d/env.sh
source $KDHIRA_DOTFILES/zshrc.d/alias.sh

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"                                       # This loads nvm
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
