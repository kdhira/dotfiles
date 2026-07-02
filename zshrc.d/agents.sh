#!/usr/bin/env bash

agent_disclose() {
    agent_prefix=$1
    zshrc_tag=${2:-"${agent_prefix}"}
    _date="$(date +%s)"

    # shellcheck disable=SC1090
    [ -f ~/".zshrc-${zshrc_tag}" ] && source ~/".zshrc-${zshrc_tag}"
    # shellcheck disable=SC1090
    [ -f ./".zshrc-${zshrc_tag}" ] && source ./".zshrc-${zshrc_tag}"

    export AI_AGENT="${AI_AGENT:-"${agent_prefix}-${_date}"}"
    export AI_AGENT_SESSION_START="${_date}"
}

# Codex
if [[ "${CODEX_SESSION:-0}" == "1" ]] \
|| [ -n "${CODEX_THREAD_ID:-""}" ] \
|| [[ "${__CFBundleIdentifier:-""}" == "com.openai.codex" ]] \
|| [[ "${PATH}" == *"${CODEX_HOME:-"${HOME}/.codex"}"* ]] \
; then
    agent_disclose codex
    export CODEX_SESSION=1
fi

# Claude Code
if [[ "${CLAUDECODE:-0}" == "1" ]] \
|| [[ "${AI_AGENT}" == "claude-code"* ]] \
; then
    agent_disclose claude-code claude
    export CLAUDECODE=1
    export CLAUDE_CODE_SESSION=1
fi

unset -f agent_disclose
