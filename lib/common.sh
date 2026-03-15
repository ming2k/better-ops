#!/bin/bash
set -euo pipefail

# Common functions and variables used across all scripts
# This file should be sourced by scripts that need shared functionality

# Ensure PROJECT_ROOT is set
if [ -z "${PROJECT_ROOT:-}" ]; then
    SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
    source "$SCRIPT_DIR/init.sh"
fi

# Source required libraries
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/banner-generator.sh"

# Common variables
export BETTER_OPS_VERSION="2.0.0"
export BETTER_OPS_CONFIG_DIR="$HOME/.config/better-ops"

#######################################
# Create the better-ops config directory if it doesn't exist
#######################################
create_config_dir() {
    if [ ! -d "$BETTER_OPS_CONFIG_DIR" ]; then
        mkdir -p "$BETTER_OPS_CONFIG_DIR"
        log "Created config directory: $BETTER_OPS_CONFIG_DIR"
    fi
}

#######################################
# Backup an existing file with a timestamp
# Arguments:
#   $1 - Relative path from $HOME (e.g. ".bashrc")
#######################################
backup_file() {
    local file="$HOME/$1"
    if [ -f "$file" ]; then
        local backup="${file}.better-ops-backup.$(date +%Y%m%d-%H%M%S)"
        cp -p "$file" "$backup"
        chmod 600 "$backup"
        log "Backed up $file to $backup"

        create_config_dir
        echo "$backup" >> "$BETTER_OPS_CONFIG_DIR/backups.list"
    fi
}

# Check if running in container
is_container() {
    [ -f /.dockerenv ] || [ -f /.containerenv ] || grep -q 'container=docker\|container=podman' /proc/1/environ 2>/dev/null
}

#######################################
# Install a config directory to $HOME
# Arguments:
#   $1 - Source directory
#   $2 - Relative destination from $HOME (e.g. ".config/zsh")
#######################################
install_config() {
    local source_dir="$1"
    local dest_dir="$HOME/$2"

    [ ! -d "$source_dir" ] && { log "error" "Source directory $source_dir does not exist"; return 1; }

    mkdir -p "$dest_dir"
    cp -r "$source_dir"/* "$dest_dir/"
    log "Installed config to $dest_dir"
}

#######################################
# Install a single file to $HOME
# Arguments:
#   $1 - Source file path
#   $2 - Relative destination from $HOME (e.g. ".bashrc")
#######################################
install_file() {
    local source_file="$1"
    local dest_file="$HOME/$2"

    [ ! -f "$source_file" ] && { log "error" "Source file $source_file does not exist"; return 1; }

    mkdir -p "$(dirname "$dest_file")"
    cp "$source_file" "$dest_file"
    log "Installed $dest_file"
}
