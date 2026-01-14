#!/bin/bash

# Common functions and variables used across all scripts
# This file should be sourced by scripts that need shared functionality

# Ensure PROJECT_ROOT is set
if [ -z "$PROJECT_ROOT" ]; then
    PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")")
fi

# Source required libraries
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/banner-generator.sh"

# Common variables
export BETTER_OPS_VERSION="1.0.0"
export BETTER_OPS_CONFIG_DIR="$HOME/.config/better-ops"

# Create config directory if it doesn't exist
create_config_dir() {
    if [ ! -d "$BETTER_OPS_CONFIG_DIR" ]; then
        mkdir -p "$BETTER_OPS_CONFIG_DIR"
        log "Created config directory: $BETTER_OPS_CONFIG_DIR"
    fi
}

# Backup existing file with timestamp
backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        local backup_file="${file}.better-ops-backup.$(date +%Y%m%d-%H%M%S)"
        cp "$file" "$backup_file"
        log "Backed up $file to $backup_file"

        # Ensure config directory exists before writing backups.list
        create_config_dir
        echo "$backup_file" >> "$BETTER_OPS_CONFIG_DIR/backups.list"
    fi
}

# Check if running in container
is_container() {
    [ -f /.dockerenv ] || [ -f /.containerenv ] || grep -q 'container=docker\|container=podman' /proc/1/environ 2>/dev/null
}

# Validate command exists and is executable
check_command() {
    local cmd="$1"
    local required="${2:-false}"
    
    if command -v "$cmd" &> /dev/null; then
        log "✓ $cmd is available"
        return 0
    else
        if [ "$required" = "true" ]; then
            log "error" "✗ Required command '$cmd' not found"
            return 1
        else
            log "warn" "✗ Optional command '$cmd' not found"
            return 1
        fi
    fi
}

# Validate file exists and has expected content
validate_file_content() {
    local file="$1"
    local pattern="$2"
    local description="${3:-content}"
    
    if [ ! -f "$file" ]; then
        log "error" "✗ File $file does not exist"
        return 1
    fi
    
    if grep -q "$pattern" "$file"; then
        log "✓ $file contains expected $description"
        return 0
    else
        log "error" "✗ $file missing expected $description"
        return 1
    fi
}

# Get system info for validation
get_system_info() {
    cat > "$BETTER_OPS_CONFIG_DIR/system-info.txt" << EOF
Better-Ops Installation Info
============================
Date: $(date)
User: $(whoami)
Hostname: $(hostname)
OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)
Kernel: $(uname -r)
Shell: $SHELL
Container: $(is_container && echo "Yes" || echo "No")
EOF
}

# Get target users for config installation (root + original user if using sudo)
get_target_users() {
    local users=()
    users+=("$(whoami)")
    if [ -n "$SUDO_USER" ] && [ "$SUDO_USER" != "root" ]; then
        users+=("$SUDO_USER")
    fi
    printf '%s\n' "${users[@]}" | sort -u
}

# Get home directory for a given user
get_user_home() {
    local user="$1"
    if [ "$user" = "root" ]; then
        echo "/root"
    else
        echo "/home/$user"
    fi
}

# Install config directory for a specific user
install_config_for_user() {
    local user="$1"
    local source_dir="$2"
    local dest_relative="$3"
    local user_home=$(get_user_home "$user")
    local dest_dir="$user_home/$dest_relative"

    [ ! -d "$source_dir" ] && { log "error" "Source directory $source_dir does not exist"; return 1; }

    mkdir -p "$dest_dir"
    cp -r "$source_dir"/* "$dest_dir/"
    [ "$user" != "root" ] && chown -R "$user:$user" "$dest_dir"
    log "Installed config to $dest_dir for user $user"
}

# Install a single file for a specific user
install_file_for_user() {
    local user="$1"
    local source_file="$2"
    local dest_relative="$3"
    local user_home=$(get_user_home "$user")
    local dest_file="$user_home/$dest_relative"

    [ ! -f "$source_file" ] && { log "error" "Source file $source_file does not exist"; return 1; }

    mkdir -p "$(dirname "$dest_file")"
    cp "$source_file" "$dest_file"
    [ "$user" != "root" ] && chown "$user:$user" "$dest_file"
    log "Installed $dest_file for user $user"
}

# Backup file for a specific user
backup_file_for_user() {
    local user="$1"
    local file_relative="$2"
    local user_home=$(get_user_home "$user")
    local file="$user_home/$file_relative"

    if [ -f "$file" ]; then
        local backup_file="${file}.better-ops-backup.$(date +%Y%m%d-%H%M%S)"
        cp "$file" "$backup_file"
        [ "$user" != "root" ] && chown "$user:$user" "$backup_file"
        log "Backed up $file to $backup_file"
    fi
}