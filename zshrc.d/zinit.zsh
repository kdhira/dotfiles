#!/usr/bin/env zsh

# Inspired by https://www.youtube.com/watch?v=ud7YxC33Z3w

# https://github.com/zdharma-continuum/zinit?tab=readme-ov-file#manual
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Shallow clones only
zinit ice depth=1

# Plugins
if [[ $KDHIRA_PROMPT_STRATEGY == 'pl10k' ]]; then
    source $KDHIRA_DOTFILES/zshrc.d/powerlevel10k.sh
    zinit light romkatv/powerlevel10k
fi
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Snippets
zinit snippet OMZP::aws
zinit snippet OMZP::thefuck

# Binds
# bindkey '^p' history-search-backward
bindkey '^[[A' history-search-backward
# bindkey '^n' history-search-forward
bindkey '^[[B' history-search-forward

# History
HISTSIZE=1000000
HISTFILE=$HOME/.zsh_history
SAVEHIST=1000000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
# zstyle ':fzf-tab:complete:ls:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'