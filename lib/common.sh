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
export BETTER_OPS_VERSION="1.0.0"
export BETTER_OPS_CONFIG_DIR="$HOME/.config/better-ops"

#######################################
# Create the better-ops config directory if it doesn't exist
# Globals:
#   BETTER_OPS_CONFIG_DIR
# Arguments:
#   None
# Outputs:
#   Log message if directory is created
#######################################
create_config_dir() {
    if [ ! -d "$BETTER_OPS_CONFIG_DIR" ]; then
        mkdir -p "$BETTER_OPS_CONFIG_DIR"
        log "Created config directory: $BETTER_OPS_CONFIG_DIR"
    fi
}

#######################################
# Backup an existing file with a timestamp
# Creates a backup with format: filename.better-ops-backup.YYYYMMDD-HHMMSS
# Backup is recorded in the backups.list file
# Globals:
#   BETTER_OPS_CONFIG_DIR
# Arguments:
#   $1 - Path to file to backup
# Outputs:
#   Log message confirming backup
# Example:
#   backup_file "/etc/hosts"
#######################################
backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        local backup_file="${file}.better-ops-backup.$(date +%Y%m%d-%H%M%S)"
        cp -p "$file" "$backup_file"
        chmod 600 "$backup_file"
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

#######################################
# Validate that a directory exists and is writable
# Arguments:
#   $1 - Directory path to validate
#   $2 - (Optional) Description of directory for error messages
# Returns:
#   0 if directory exists and is writable
#   1 if directory doesn't exist or is not writable
# Outputs:
#   Error messages via log function
# Example:
#   validate_writable_dir "/tmp" "temporary directory"
#######################################
validate_writable_dir() {
    local dir="$1"
    local description="${2:-directory}"

    if [ ! -d "$dir" ]; then
        log "error" "$description does not exist: $dir"
        return 1
    fi

    if [ ! -w "$dir" ]; then
        log "error" "$description is not writable: $dir"
        return 1
    fi

    return 0
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

#######################################
# Get list of target users for config installation
# Returns current user and original user if running via sudo
# Globals:
#   SUDO_USER
# Arguments:
#   None
# Outputs:
#   Newline-separated list of unique usernames to stdout
# Example:
#   for user in $(get_target_users); do
#     echo "Installing for $user"
#   done
#######################################
get_target_users() {
    local users=()
    users+=("$(whoami)")
    if [ -n "${SUDO_USER:-}" ] && [ "$SUDO_USER" != "root" ]; then
        users+=("$SUDO_USER")
    fi
    printf '%s\n' "${users[@]}" | sort -u
}

# Execute a callback function for each target user
for_each_target_user() {
    local callback_fn="$1"
    shift

    local users
    users=$(get_target_users)

    while IFS= read -r user; do
        [ -z "$user" ] && continue
        log "Processing for user: $user"
        "$callback_fn" "$user" "$@"
    done <<< "$users"
}

# Initialize a setup module with common setup
# This function is meant to be called from setup scripts
init_setup_module() {
    local module_name="$1"

    # PROJECT_ROOT should already be set by the sourcing script
    # but we ensure common.sh is sourced (which this file is)

    # Generate banner
    generate_banner "$module_name"
}

#######################################
# Get the home directory for a given user
# Arguments:
#   $1 - username
# Outputs:
#   Prints home directory path to stdout
# Returns:
#   0 on success
# Example:
#   user_home=$(get_user_home "root")  # Returns "/root"
#   user_home=$(get_user_home "alice") # Returns "/home/alice"
#######################################
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
        cp -p "$file" "$backup_file"
        chmod 600 "$backup_file"
        [ "$user" != "root" ] && chown "$user:$user" "$backup_file"
        log "Backed up $file to $backup_file"
    fi
}