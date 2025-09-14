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