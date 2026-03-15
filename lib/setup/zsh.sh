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

# Check required commands are available
require_command zsh fzf

log "Installing zsh configuration for user: $(whoami)"

# Backup existing configurations
backup_file ".zshrc"
backup_file ".zprofile"

# Install shared configuration to XDG config dir
install_config "$PROJECT_ROOT/config/shared" ".config/shell-shared"

# Install custom zshrc
install_file "$PROJECT_ROOT/config/zsh/.zshrc" ".zshrc"

# Install zsh config directory to XDG config dir
install_config "$PROJECT_ROOT/config/zsh/.zsh" ".config/zsh"

# Set zsh as default shell
if command -v chsh >/dev/null 2>&1; then
    chsh -s "$(command -v zsh)" 2>/dev/null || true
    log "Set zsh as default shell"
fi

log "Zsh configuration complete."
