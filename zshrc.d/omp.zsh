#!/usr/bin/env zsh

export OMP_MODE="${OMP_MODE:-full}"
omp-toggle() {
    export OMP_MODE=$([[ "$OMP_MODE" == "full" ]] && echo compact || echo full)
    # Simulate pressing Enter on an empty command
    BUFFER=""
    zle accept-line 2>/dev/null || true
}
zle -N omp-toggle
bindkey '^O' omp-toggle
