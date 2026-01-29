#!/usr/bin/env zsh

###############################################################################
# KDHIRA DOTFILES ZSHRC
# Author: Kevin Hira
#
# Environment Variables (set in ~/.zshenv):
# > Required
#   - KDHIRA_DOTFILES: Directory to dotfiles repo clone
# > Optional
#   - KDHIRA_ZSH_COMPLETIONS_DIR: Directory for zsh_completions
#     (Default: "$HOME/.zsh_completions")
###############################################################################

# Homebrew init
# LOADS:
#   HOMEBREW_PREFIX
source $KDHIRA_DOTFILES/zshrc.d/homebrew.sh

if [[ $TERM_PROGRAM == 'iTerm.app' ]]; then
    [ -f "$HOME/.iterm2_shell_integration.zsh" ] && source "$HOME/.iterm2_shell_integration.zsh"
fi

source $KDHIRA_DOTFILES/zshrc.d/zinit.zsh

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

# oh-my-posh setup
command -v oh-my-posh &>/dev/null || brew install oh-my-posh
eval "$(oh-my-posh init zsh --config $KDHIRA_DOTFILES/oh-my-posh/omp.toml)"
source $KDHIRA_DOTFILES/zshrc.d/omp.zsh

# fnm (Fast Node Manager) - so much better than nvm
command -v fnm &>/dev/null || brew install fnm
eval "$(fnm env --use-on-cd --shell zsh)"

source $KDHIRA_DOTFILES/zshrc.d/env.sh
source $KDHIRA_DOTFILES/zshrc.d/alias.sh
source $KDHIRA_DOTFILES/zshrc.d/zsh_completions.zsh

unsetopt AUTO_CD
autoload -U compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Per-machine customisations
if [ -f ~/.zshrc-user ]; then
    source ~/.zshrc-user
fi

if [[ "${CODEX_SESSION_FORCE:-0}" == "1" ]] || [[ "${PATH}" == *"${CODEX_HOME:-"${HOME}/.codex"}"* ]]; then
    [ -f ~/.zshrc-codex ] && source ~/.zshrc-codex
    [ -f ./.zshrc-codex ] && source ./.zshrc-codex
    export CODEX_SESSION=1
fi

if type zinit &>/dev/null; then
    zinit cdreplay -q
fi
