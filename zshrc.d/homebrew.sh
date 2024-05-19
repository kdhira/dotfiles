#!/usr/bin/env bash

if [ "$(uname)" = 'Darwin' ]; then
    if [ ! -f /usr/local/bin/brew ] && [ ! -f /opt/homebrew/bin/brew ]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # This sets $HOMEBREW_PREFIX and other stuff for homebrew depending on Intel vs Apple Silicon
    test -f /usr/local/bin/brew && eval "$(/usr/local/bin/brew shellenv)"
    test -f /opt/homebrew/bin/brew && eval "$(/opt/homebrew/bin/brew shellenv)"

elif [ "$(uname)" = 'Linux' ]; then
    test -s /home/linuxbrew/.linuxbrew/bin/brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# https://docs.brew.sh/Shell-Completion#:~:text=In%20this%20case%2C%20instead%20of%20the%20above%2C%20add%20the%20following%20line%20to%20your%20~/.zshrc%2C%20before%20you%20source%20oh%2Dmy%2Dzsh.sh
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
