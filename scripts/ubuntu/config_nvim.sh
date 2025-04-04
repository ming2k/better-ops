#!/bin/bash

PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
source $PROJECT_ROOT/lib/banner-generator.sh
source $PROJECT_ROOT/lib/log.sh

generate_banner "SETTING NVIM"

# Use PPA to install newer Neovim
sudo add-apt-repository ppa:neovim-ppa/stable -y
sudo apt-get update
sudo apt-get install neovim -y

# Setup Neovim config directory
nvim_config_dir="$HOME/.config/nvim"

# Create Neovim config directory (if it doesn't exist)
if [ ! -d "$nvim_config_dir" ]; then
    mkdir -p "$nvim_config_dir"
fi

# Move existing config to backup directory
if [ -d "$nvim_config_dir" ]; then
    mv "$nvim_config_dir" "$nvim_config_dir.bak"
fi

# Copy all config
if [ -d "$PROJECT_ROOT/assets/nvim_config" ]; then
    cp -R "$PROJECT_ROOT/assets/nvim_config/"* "$nvim_config_dir/"
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