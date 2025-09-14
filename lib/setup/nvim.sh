#!/bin/bash

PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
source $PROJECT_ROOT/lib/banner-generator.sh
source $PROJECT_ROOT/lib/log.sh

generate_banner "SETTING NVIM"

NVIM_VERSION="v0.11.1"
URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.appimage"
# Check if Neovim is already installed
if command -v nvim &> /dev/null; then
    log "Neovim is already installed."
    exit 0
fi
# Download Neovim if not installed or version is different
if [ -f /usr/local/bin/nvim ]; then
    CURRENT_VERSION=$(/usr/local/bin/nvim --version | head -n 1 | awk '{print $2}')
    if [ "$CURRENT_VERSION" == "$NVIM_VERSION" ]; then
        log "Neovim version $NVIM_VERSION is already installed."
        exit 0
    else
        log "Updating Neovim from version $CURRENT_VERSION to $NVIM_VERSION."
        wget $URL -O /usr/local/bin/nvim
    fi
else
    log "Installing Neovim version $NVIM_VERSION."
    wget $URL -O /usr/local/bin/nvim
fi
chmod u+x /usr/local/bin/nvim
# Clear the hash table for nvim to ensure the new binary is recognized
hash -d nvim 2>/dev/null || true

# Setup Neovim config directory
NVIM_CONFIG_DIR="$HOME/.config/nvim"

# Create Neovim config directory (if it doesn't exist)
if [ ! -d "$NVIM_CONFIG_DIR" ]; then
    mkdir -p "$NVIM_CONFIG_DIR"
fi

# Move existing config to backup directory
if [ -d "$NVIM_CONFIG_DIR" ]; then
    mv "$NVIM_CONFIG_DIR" "$NVIM_CONFIG_DIR.bak"
fi

# Copy all config
if [ -d "$PROJECT_ROOT/config/nvim" ]; then
    cp -R "$PROJECT_ROOT/config/nvim/"* "$NVIM_CONFIG_DIR/"
    log "Neovim configuration files copied successfully."
else
    log "error" "Error: Neovim configuration directory not found at $PROJECT_ROOT/config/nvim"
    exit 1
fi

# Setup EDITOR environment variable
if ! grep -q "export EDITOR=nvim" ~/.bashrc; then
    echo -e "\nexport EDITOR=nvim" >> ~/.bashrc
    log "EDITOR environment variable set to nvim in ~/.bashrc"
else
    log "EDITOR environment variable already set to nvim in ~/.bashrc"
fi

# Reload .bashrc
source ~/.bashrc

log "Neovim setup completed."
