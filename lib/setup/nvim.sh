#!/bin/bash
set -euo pipefail

# Initialize project root if not already set
if [ -z "${PROJECT_ROOT:-}" ]; then
    SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
    source "$SCRIPT_DIR/../init.sh"
fi

source "$PROJECT_ROOT/lib/common.sh"
source "$PROJECT_ROOT/lib/install-package.sh"

generate_banner "SETTING NVIM"

# Check that nvim is installed
require_command nvim

log "Installing Neovim configuration for user: $(whoami)"

NVIM_CONFIG_DIR="$HOME/.config/nvim"

# Backup existing config if it exists
if [ -d "$NVIM_CONFIG_DIR" ]; then
    BACKUP_DIR="$NVIM_CONFIG_DIR.bak.$(date +%Y%m%d-%H%M%S)"
    log "Backing up existing Neovim config to $BACKUP_DIR"
    mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
fi

# Create and copy config
if [ -d "$PROJECT_ROOT/config/nvim" ]; then
    mkdir -p "$NVIM_CONFIG_DIR"
    cp -R "$PROJECT_ROOT/config/nvim/"* "$NVIM_CONFIG_DIR/"
    log "Neovim configuration files copied"
else
    log "error" "Neovim configuration directory not found at $PROJECT_ROOT/config/nvim"
    exit 1
fi

log "Neovim configuration complete."
