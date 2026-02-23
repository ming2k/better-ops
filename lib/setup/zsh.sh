#!/bin/bash
set -euo pipefail

# Initialize project root if not already set
if [ -z "${PROJECT_ROOT:-}" ]; then
    SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
    source "$SCRIPT_DIR/../init.sh"
fi

source "$PROJECT_ROOT/lib/common.sh"
source "$PROJECT_ROOT/lib/install-package.sh"

generate_banner "SETTING ZSH"

# Install packages first (system-wide)
install_package zsh
install_package zsh-completions 2>/dev/null || true
install_package fzf

# Configure for specified user only; skip if no user given
if [ -z "${SETUP_USER:-}" ]; then
    log "No --user specified, skipping user configuration"
else
    user="$SETUP_USER"
    log "Installing zsh configuration for user: $user"

    # Backup existing configurations
    backup_file_for_user "$user" ".zshrc"
    backup_file_for_user "$user" ".zprofile"

    # Install custom zshrc
    install_file_for_user "$user" "$PROJECT_ROOT/config/zsh/.zshrc" ".zshrc"

    # Install zsh config directory
    install_config_for_user "$user" "$PROJECT_ROOT/config/zsh/.zsh" ".zsh"

    # Set zsh as default shell for user
    if command -v usermod >/dev/null 2>&1; then
        zsh_path=$(command -v zsh)
        usermod -s "$zsh_path" "$user" 2>/dev/null || true
        log "Set zsh as default shell for $user"
    fi

    # Set zsh as default shell for new users
    if [ -f /etc/default/useradd ]; then
        sed -i "s|^SHELL=.*|SHELL=$zsh_path|" /etc/default/useradd 2>/dev/null || true
        log "Set zsh as default shell for new users"
    fi

    log "Zsh user configuration complete for $user."
fi
