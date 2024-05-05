#!/bin/bash

test -f /opt/homebrew/bin/brew && eval "$(/opt/homebrew/bin/brew shellenv)"

# https://docs.brew.sh/Shell-Completion#:~:text=In%20this%20case%2C%20instead%20of%20the%20above%2C%20add%20the%20following%20line%20to%20your%20~/.zshrc%2C%20before%20you%20source%20oh%2Dmy%2Dzsh.sh
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
