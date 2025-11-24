#!/bin/bash

PROJECT_ROOT=$(dirname "$(dirname "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")")")
source $PROJECT_ROOT/lib/banner-generator.sh
source $PROJECT_ROOT/lib/log.sh

generate_banner "SETTING NVIM"

NVIM_VERSION="v0.11.1"
URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.appimage"

# Check if Neovim is already installed with correct version
if [ -f /usr/local/bin/nvim ]; then
    CURRENT_VERSION=$(/usr/local/bin/nvim --version 2>/dev/null | head -n 1 | awk '{print $2}')
    if [ "$CURRENT_VERSION" == "$NVIM_VERSION" ]; then
        log "Neovim version $NVIM_VERSION is already installed."
    else
        log "Updating Neovim from version $CURRENT_VERSION to $NVIM_VERSION."
        wget -q $URL -O /usr/local/bin/nvim
        chmod u+x /usr/local/bin/nvim
    fi
else
    log "Installing Neovim version $NVIM_VERSION."
    wget -q $URL -O /usr/local/bin/nvim
    chmod u+x /usr/local/bin/nvim
fi

# Clear the hash table for nvim to ensure the new binary is recognized
hash -d nvim 2>/dev/null || true

# Setup Neovim config directory
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
    log "Neovim configuration files copied successfully."
else
    log "error" "Error: Neovim configuration directory not found at $PROJECT_ROOT/config/nvim"
    exit 1
fi

# Setup EDITOR environment variable in bash exports
EXPORTS_FILE="$HOME/.bash/exports/editor.bash"
mkdir -p "$HOME/.bash/exports"

if [ ! -f "$EXPORTS_FILE" ] || ! grep -q "export EDITOR=nvim" "$EXPORTS_FILE"; then
    echo "# Default editor" > "$EXPORTS_FILE"
    echo "export EDITOR=nvim" >> "$EXPORTS_FILE"
    echo "export VISUAL=nvim" >> "$EXPORTS_FILE"
    log "EDITOR environment variable set to nvim in $EXPORTS_FILE"
else
    log "EDITOR environment variable already configured"
fi

log "Neovim setup completed."
