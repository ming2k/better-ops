#!/usr/bin/env zsh

_config_home="${XDG_CONFIG_HOME:-$HOME/.config}"

# Load shared configuration (shell-agnostic aliases, exports, etc.)
for f in "$_config_home"/shell-shared/{exports,aliases,functions}/*.sh(N); do
    source "$f"
done

# Load zsh-specific configuration files
for f in "$_config_home"/zsh/{config,exports,aliases,functions,prompts,completions}/*.{zsh,sh}(N); do
    source "$f"
done

# Load tool initializations (eval statements run last)
for f in "$_config_home"/zsh/init/*.{zsh,sh}(N); do
    source "$f"
done

# Add scripts to PATH
export PATH="$PATH:$_config_home/shell-shared/scripts:$_config_home/zsh/scripts"

unset _config_home
