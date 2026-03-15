#!/bin/bash
set -euo pipefail

# Initialize project root if not already set
if [ -z "${PROJECT_ROOT:-}" ]; then
    SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
    source "$SCRIPT_DIR/../init.sh"
fi

source "$PROJECT_ROOT/lib/common.sh"
source "$PROJECT_ROOT/lib/install-package.sh"

generate_banner "SETTING BASH"

# Check required commands are available
require_command bash fzf

log "Installing bash configuration for user: $(whoami)"

# Backup existing configurations
backup_file ".bashrc"
backup_file ".bash_profile"

# Install shared configuration to XDG config dir
install_config "$PROJECT_ROOT/config/shared" ".config/shell-shared"

# Install custom bashrc and bash_profile
install_file "$PROJECT_ROOT/config/bash/.bash_profile" ".bash_profile"
install_file "$PROJECT_ROOT/config/bash/.bashrc" ".bashrc"

# Install bash config directory to XDG config dir
install_config "$PROJECT_ROOT/config/bash/.bash" ".config/bash"

# Set bash as default shell
if command -v chsh >/dev/null 2>&1; then
    chsh -s /bin/bash 2>/dev/null || true
    log "Set bash as default shell"
fi

log "Bash configuration complete."
