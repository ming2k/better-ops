#!/bin/bash

# History file location
export HISTFILE=~/.bash_history

# Increase history size dramatically
export HISTSIZE=100000          # Number of commands in memory
export HISTFILESIZE=200000      # Number of commands in history file

# History control options
export HISTCONTROL="ignoreboth:erasedups"
# ignoreboth = ignorespace + ignoredups
# ignorespace: don't save commands starting with space
# ignoredups: don't save duplicate commands
# erasedups: remove all previous duplicate commands

# Save timestamp with each command
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "

# Commands to ignore (won't be saved in history)
export HISTIGNORE="ls:ll:la:pwd:exit:clear:history:bg:fg:jobs"

# Append to history file instead of overwriting
shopt -s histappend

# Save multi-line commands as single entry
shopt -s cmdhist

# Save history immediately after each command
# PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"