#!/usr/bin/env bash

if [[ "${CODEX_SESSION:-0}" == "1" ]] \
    || [ -n "${CODEX_THREAD_ID:-""}" ] \
    || [[ "${__CFBundleIdentifier:-""}" == "com.openai.codex" ]] \
    || [[ "${PATH}" == *"${CODEX_HOME:-"${HOME}/.codex"}"* ]]; then
    # shellcheck disable=SC1090
    [ -f ~/.zshrc-codex ] && source ~/.zshrc-codex
    # shellcheck disable=SC1091
    [ -f ./.zshrc-codex ] && source ./.zshrc-codex
    export CODEX_SESSION=1
fi
