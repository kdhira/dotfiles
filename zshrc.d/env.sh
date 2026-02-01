#!/usr/bin/env bash

zsh_path_stack() {
    test -d "$1" && export PATH="$1:$PATH"
}

zsh_path_queue() {
    test -d "$1" && export PATH="$PATH:$1"
}

zsh_path_stack "$HOME/go/bin"
zsh_path_stack "$HOME/bin"
zsh_path_stack "$HOME/.cargo/bin"
