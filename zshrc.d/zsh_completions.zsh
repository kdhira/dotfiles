#!/usr/bin/env zsh

ZSH_COMPLETIONS_DIR=${KDHIRA_ZSH_COMPLETIONS_DIR:-"$HOME/.zsh_completions"}
test -d "$ZSH_COMPLETIONS_DIR" || mkdir "${ZSH_COMPLETIONS_DIR}"
if [[ ! " ${fpath[@]} " =~ " $ZSH_COMPLETIONS_DIR " ]]; then
    export fpath=($ZSH_COMPLETIONS_DIR $fpath)
fi

zsh_completions_add() {
    for cmd in "$@"; do
        if which "${cmd}" &>/dev/null && [ ! -f "$ZSH_COMPLETIONS_DIR/_${cmd}" ]; then
            "${cmd}" completion zsh >"$ZSH_COMPLETIONS_DIR/_${cmd}"
        fi
    done
}
