#!/bin/bash
# Bash module loader
# This file loads all bash configuration modules in the correct order

BASH_DIR="$HOME/.bash"

# Load configuration (shell options, history settings, etc.)
for config_file in "$BASH_DIR/config"/*.bash; do
    [ -r "$config_file" ] && source "$config_file"
done

# Load exports (environment variables)
for export_file in "$BASH_DIR/exports"/*.bash; do
    [ -r "$export_file" ] && source "$export_file"
done

# Load functions
for function_file in "$BASH_DIR/functions"/*.bash; do
    [ -r "$function_file" ] && source "$function_file"
done

# Load aliases
for alias_file in "$BASH_DIR/aliases"/*.bash; do
    [ -r "$alias_file" ] && source "$alias_file"
done

# Load prompts
for prompt_file in "$BASH_DIR/prompts"/*.sh "$BASH_DIR/prompts"/*.bash; do
    [ -r "$prompt_file" ] && source "$prompt_file"
done

# Load completions
for completion_file in "$BASH_DIR/completions"/*.sh "$BASH_DIR/completions"/*.bash; do
    [ -r "$completion_file" ] && source "$completion_file"
done

# Load utils (helper scripts)
for util_file in "$BASH_DIR/utils"/*.bash; do
    [ -r "$util_file" ] && source "$util_file"
done

# Load tools (fzf, etc.)
for tool_file in "$BASH_DIR/tools"/*.bash; do
    [ -r "$tool_file" ] && source "$tool_file"
done
