#!/bin/bash

_config_home="${XDG_CONFIG_HOME:-$HOME/.config}"

# Load shared configuration (shell-agnostic aliases, exports, etc.)
for f in "$_config_home"/shell-shared/{exports,aliases,functions}/*.sh; do
    [[ -r "$f" ]] && source "$f"
done

# Load bash-specific configuration files
for f in "$_config_home"/bash/{config,exports,aliases,functions,prompts,completions}/*.{bash,sh}; do
    [[ -r "$f" ]] && source "$f"
done

# Load tool initializations (eval statements run last)
for f in "$_config_home"/bash/init/*.{bash,sh}; do
    [[ -r "$f" ]] && source "$f"
done

# Add scripts to PATH
export PATH="$PATH:$_config_home/shell-shared/scripts:$_config_home/bash/scripts"

unset _config_home
