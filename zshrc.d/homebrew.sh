#!/usr/bin/env bash

if [ "$(uname)" = 'Darwin' ]; then
    # This sets $HOMEBREW_PREFIX and other stuff for homebrew depending on Intel vs Apple Silicon
    test -f /usr/local/bin/brew && eval "$(/usr/local/bin/brew shellenv)"
    test -f /opt/homebrew/bin/brew && eval "$(/opt/homebrew/bin/brew shellenv)"
fi
