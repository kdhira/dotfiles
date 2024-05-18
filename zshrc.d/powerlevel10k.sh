#!/usr/bin/env bash

# powerlevel9k settings
# shellcheck disable=SC2034
POWERLEVEL9K_STATUS_CROSS=false
POWERLEVEL9K_STATUS_OK=false

POWERLEVEL9K_STATUS_ERROR_FOREGROUND='000'
POWERLEVEL9K_STATUS_ERROR_BACKGROUND='004'

POWERLEVEL9K_HIDE_BRANCH_ICON=true
POWERLEVEL9K_SHOW_CHANGESET=true

POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND='008'
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND='007'

PL9K_DIR_BACKGROUND='007'
PL9K_DIR_FOREGROUND='000'
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND=$PL9K_DIR_BACKGROUND
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND=$PL9K_DIR_FOREGROUND
POWERLEVEL9K_DIR_HOME_BACKGROUND=$PL9K_DIR_BACKGROUND
POWERLEVEL9K_DIR_HOME_FOREGROUND=$PL9K_DIR_FOREGROUND
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND=$PL9K_DIR_BACKGROUND
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND=$PL9K_DIR_FOREGROUND
POWERLEVEL9K_DIR_ETC_BACKGROUND=$PL9K_DIR_BACKGROUND
POWERLEVEL9K_DIR_ETC_FOREGROUND=$PL9K_DIR_FOREGROUND

POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='007'
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='000'

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(command_execution_time status context dir vcs aws)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
