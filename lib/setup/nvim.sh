#!/bin/bash
set -euo pipefail

# Initialize project root if not already set
if [ -z "${PROJECT_ROOT:-}" ]; then
    SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
    source "$SCRIPT_DIR/../init.sh"
fi

source "$PROJECT_ROOT/lib/common.sh"

generate_banner "SETTING NVIM"

# Neovim configuration (hardcoded for stability)
NVIM_VERSION="v0.11.1"
NVIM_PATH="/usr/local/bin/nvim"
NVIM_SHA256="7f89b0de9e74481aab58acf90cafc049fb04197c5630ddfbb8ca7abb638570da"
URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.appimage"

# Download and verify Neovim binary
download_and_verify_nvim() {
    local temp_file="$NVIM_PATH.tmp"

    log "Downloading Neovim from $URL"
    if ! sudo wget -q "$URL" -O "$temp_file"; then
        log "error" "Failed to download Neovim from $URL"
        return 1
    fi

    log "Verifying checksum..."
    local actual_sha256=$(sha256sum "$temp_file" | awk '{print $1}')
    if [ "$actual_sha256" != "$NVIM_SHA256" ]; then
        log "error" "Checksum verification failed"
        log "error" "Expected: $NVIM_SHA256"
        log "error" "Got:      $actual_sha256"
        sudo rm -f "$temp_file"
        return 1
    fi

    sudo mv "$temp_file" "$NVIM_PATH"
    sudo chmod u+x "$NVIM_PATH"
    log "Neovim installed successfully"
    return 0
}

# Install Neovim binary (system-wide)
if [ -f "$NVIM_PATH" ]; then
    CURRENT_VERSION=$("$NVIM_PATH" --version 2>/dev/null | head -n 1 | awk '{print $2}')
    if [ "$CURRENT_VERSION" == "$NVIM_VERSION" ]; then
        log "Neovim version $NVIM_VERSION is already installed."
    else
        log "Updating Neovim from version $CURRENT_VERSION to $NVIM_VERSION."
        if ! download_and_verify_nvim; then
            exit 1
        fi
    fi
else
    log "Installing Neovim version $NVIM_VERSION."
    if ! download_and_verify_nvim; then
        exit 1
    fi
fi

# Clear the hash table for nvim
hash -d nvim 2>/dev/null || true

# Get target users (root + original user if using sudo)
TARGET_USERS=$(get_target_users)

# Install nvim config for each target user
for user in $TARGET_USERS; do
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

    # Setup EDITOR environment variable in bash exports
    EXPORTS_DIR="$user_home/.bash/exports"
    EXPORTS_FILE="$EXPORTS_DIR/editor.bash"
    mkdir -p "$EXPORTS_DIR"

    if [ ! -f "$EXPORTS_FILE" ] || ! grep -q "export EDITOR=nvim" "$EXPORTS_FILE"; then
        echo "# Default editor" > "$EXPORTS_FILE"
        echo "export EDITOR=nvim" >> "$EXPORTS_FILE"
        echo "export VISUAL=nvim" >> "$EXPORTS_FILE"
        [ "$user" != "root" ] && chown -R "$user:$user" "$EXPORTS_DIR"
        log "EDITOR environment variable set for $user"
    else
        log "EDITOR environment variable already configured for $user"
    fi
done

log "Neovim setup completed for all users."
