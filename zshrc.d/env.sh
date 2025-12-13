#!/usr/bin/env bash

test -d "$HOME/go/bin" && export PATH="$HOME/go/bin:$PATH"

# Always export ~/bin to PATH
export PATH="$HOME/bin:$PATH"

test -d "$HOME/.cargo/bin" && export PATH="$HOME/.cargo/bin:$PATH"

