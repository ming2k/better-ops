#!/bin/bash

PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
source $PROJECT_ROOT/lib/banner-generator.sh
source $PROJECT_ROOT/lib/log.sh

generate_banner "SETTING NVIM"

NVIM_VERSION="0.11.1"
URL="https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux-arm64.appimage"
wget $URL -O /usr/local/bin/nvim
chmod u+x /usr/local/bin/nvim

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
if [ -d "$PROJECT_ROOT/assets/nvim_config" ]; then
    cp -R "$PROJECT_ROOT/assets/nvim_config/"* "$NVIM_CONFIG_DIR/"
    log "Neovim configuration files copied successfully."
else
    log "error" "Error: Neovim configuration directory not found at $PROJECT_ROOT/assets/nvim_config"
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
