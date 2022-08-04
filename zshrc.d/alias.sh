#!/bin/bash

# General aliases
alias ll='ls -plaThG'

# Encrypt/decrypt with id_rsa
alias ssh-encrypt='openssl rsautl -encrypt -inkey ~/.ssh/id_rsa'
alias ssh-decrypt='openssl rsautl -decrypt -inkey ~/.ssh/id_rsa'

dotfiles() {
    _usage="dotfiles [-e|--edit]
    dotfiles -r|--reload"

    if [ -z "$KDHIRA_DOTFILES" ]; then
        echo "KDHIRA_DOTFILES not configured..." >&2
        return 1
    fi

    if [[ $# -le 1 ]] || [ $1 = '-e'] || [ $1 = '--edit']; then
        code $KDHIRA_DOTFILES
    elif [ $1 = '-r'] || [ $1 = '--reload']; then
        # TODO: Assumes zsh shell
        source ~/.zshrc
    else
        echo $_usage >&2
        return 1
    fi
}
