#!/usr/bin/env bash

# General aliases
alias ll='ls -plaThG'

# less ls
lll() {
    # shellcheck disable=SC2068
    CLICOLOR_FORCE=1 ll $@ | less
}

alias b64='base64'
alias pbj='pb | jq'

alias kevtop="tmux new-session -d -s monitors 'htop' \; split-window -v 'macmon' \; setw -g mouse on\; attach-session -t monitors"


# Encrypt/decrypt with id_rsa
ssh-encrypt() {
    openssl pkeyutl -encrypt -inkey "${1:-"$HOME/.ssh/id_rsa"}"

}
ssh-decrypt() {
    openssl pkeyutl -decrypt -inkey "${1:-"$HOME/.ssh/id_rsa"}"
}

dotfiles() {
    _usage="dotfiles [-e|--edit]
    dotfiles -r|--reload"

    if [ -z "$KDHIRA_DOTFILES" ]; then
        echo "KDHIRA_DOTFILES not configured..." >&2
        return 1
    fi

    if [[ $# -le 1 ]] || [ "$1" = '-e' ] || [ "$1" = '--edit' ]; then
        code "$KDHIRA_DOTFILES"
    elif [ "$1" = '-r' ] || [ "$1" = '--reload' ]; then
        # TODO: Assumes zsh shell
        # shellcheck disable=SC1091
        source "$HOME/.zshrc"
    else
        echo "$_usage" >&2
        return 1
    fi
}

rsamd5() {
    # shellcheck disable=SC2068
    openssl rsa -noout -modulus $@ | openssl md5
}

x509md5() {
    # shellcheck disable=SC2068
    openssl x509 -noout -modulus $@ | openssl md5
}

# MacOS pasteboard stuff
alias pb='pbpaste'
alias pbd='pbpaste | base64 -D'
alias pbe='pbpaste | base64'
alias pc='pbcopy'
alias pcd='base64 -D | pbcopy'
alias pce='base64 | pbcopy'

# X509 utils
alias x509='openssl x509'
alias x509t='openssl x509 -text'

# openssl s_client shortcuts
sslping() {
    if [[ $# -lt 1 ]]; then
        echo "Usage: $0 <target>[port]"
        return 1
    fi
    endpoint="$1"
    if [[ "$endpoint" != *:* ]]; then
        endpoint="$endpoint:443"
    fi

    : | openssl s_client -showcerts -connect "$endpoint"
}
sslx509() {
    sslping "$1" | openssl x509 -text
}
