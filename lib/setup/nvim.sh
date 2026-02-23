#!/bin/bash
set -euo pipefail

# Initialize project root if not already set
if [ -z "${PROJECT_ROOT:-}" ]; then
    SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
    source "$SCRIPT_DIR/../init.sh"
fi

source "$PROJECT_ROOT/lib/common.sh"

generate_banner "SETTING NVIM"

source "$PROJECT_ROOT/lib/install-package.sh"

# On Arch/Manjaro, install nvim via pacman
if [ "$DIST_OS" = "arch" ] || [ "$DIST_OS" = "manjaro" ]; then
    install_package neovim
else
    # Debian/Ubuntu: download appimage (hardcoded for stability)
    NVIM_VERSION="v0.11.1"
    NVIM_PATH="/usr/local/bin/nvim"
    NVIM_SHA256="7f89b0de9e74481aab58acf90cafc049fb04197c5630ddfbb8ca7abb638570da"
    URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.appimage"

    download_and_verify_nvim() {
        local temp_file="$NVIM_PATH.tmp"
        log "Downloading Neovim from $URL"
        if ! wget -q "$URL" -O "$temp_file"; then
            log "error" "Failed to download Neovim from $URL"
            return 1
        fi
        log "Verifying checksum..."
        local actual_sha256
        actual_sha256=$(sha256sum "$temp_file" | awk '{print $1}')
        if [ "$actual_sha256" != "$NVIM_SHA256" ]; then
            log "error" "Checksum verification failed"
            log "error" "Expected: $NVIM_SHA256"
            log "error" "Got:      $actual_sha256"
            rm -f "$temp_file"
            return 1
        fi
        mv "$temp_file" "$NVIM_PATH"
        chmod u+x "$NVIM_PATH"
        log "Neovim installed successfully"
    }

    if command -v nvim >/dev/null 2>&1; then
        CURRENT_VERSION=$(nvim --version 2>/dev/null | head -n 1 | awk '{print $2}')
        if [ "$CURRENT_VERSION" = "$NVIM_VERSION" ]; then
            log "Neovim $NVIM_VERSION is already installed."
        else
            log "Updating Neovim from $CURRENT_VERSION to $NVIM_VERSION."
            download_and_verify_nvim || exit 1
        fi
    else
        log "Installing Neovim $NVIM_VERSION."
        download_and_verify_nvim || exit 1
    fi
fi

# Clear the hash table for nvim
hash -d nvim 2>/dev/null || true

# Configure for specified user only; skip if no user given
if [ -z "${SETUP_USER:-}" ]; then
    log "No --user specified, skipping user configuration"
else
    user="$SETUP_USER"
    log "Installing Neovim configuration for user: $user"
    user_home=$(get_user_home "$user")
    NVIM_CONFIG_DIR="$user_home/.config/nvim"

    # Backup existing config if it exists
    if [ -d "$NVIM_CONFIG_DIR" ]; then
        BACKUP_DIR="$NVIM_CONFIG_DIR.bak.$(date +%Y%m%d-%H%M%S)"
        log "Backing up existing Neovim config to $BACKUP_DIR"
        mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
        [ "$user" != "root" ] && chown -R "$user:$user" "$BACKUP_DIR"
    fi

    # Create and copy config
    if [ -d "$PROJECT_ROOT/config/nvim" ]; then
        mkdir -p "$NVIM_CONFIG_DIR"
        cp -R "$PROJECT_ROOT/config/nvim/"* "$NVIM_CONFIG_DIR/"
        [ "$user" != "root" ] && chown -R "$user:$user" "$user_home/.config"
        log "Neovim configuration files copied for $user"
    else
        log "error" "Neovim configuration directory not found at $PROJECT_ROOT/config/nvim"
        exit 1
    fi

    # Set EDITOR in zsh exports if zsh config is present
    ZSH_EXPORTS_DIR="$user_home/.zsh/exports"
    ZSH_EXPORTS_FILE="$ZSH_EXPORTS_DIR/editor.zsh"
    if [ -d "$user_home/.zsh" ]; then
        mkdir -p "$ZSH_EXPORTS_DIR"
        if [ ! -f "$ZSH_EXPORTS_FILE" ] || ! grep -q "export EDITOR=nvim" "$ZSH_EXPORTS_FILE"; then
            printf '# Default editor\nexport EDITOR=nvim\nexport VISUAL=nvim\n' > "$ZSH_EXPORTS_FILE"
            [ "$user" != "root" ] && chown -R "$user:$user" "$ZSH_EXPORTS_DIR"
            log "EDITOR set in zsh exports for $user"
        else
            log "EDITOR already configured in zsh exports for $user"
        fi
    fi

    # Set EDITOR in bash exports if bash config is present
    BASH_EXPORTS_DIR="$user_home/.bash/exports"
    BASH_EXPORTS_FILE="$BASH_EXPORTS_DIR/editor.bash"
    if [ -d "$user_home/.bash" ]; then
        mkdir -p "$BASH_EXPORTS_DIR"
        if [ ! -f "$BASH_EXPORTS_FILE" ] || ! grep -q "export EDITOR=nvim" "$BASH_EXPORTS_FILE"; then
            printf '# Default editor\nexport EDITOR=nvim\nexport VISUAL=nvim\n' > "$BASH_EXPORTS_FILE"
            [ "$user" != "root" ] && chown -R "$user:$user" "$BASH_EXPORTS_DIR"
            log "EDITOR set in bash exports for $user"
        else
            log "EDITOR already configured in bash exports for $user"
        fi
    fi

    log "Neovim user configuration complete for $user."
fi
