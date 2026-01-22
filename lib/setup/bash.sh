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

# Install packages first (system-wide)
install_package bash-completion
install_package fzf

# Get target users (root + original user if using sudo)
TARGET_USERS=$(get_target_users)

# Install bash config for each target user
for user in $TARGET_USERS; do
    log "Installing bash configuration for user: $user"
    user_home=$(get_user_home "$user")

    # Backup existing configurations
    backup_file_for_user "$user" ".bashrc"
    backup_file_for_user "$user" ".bash_profile"

    # Install custom bashrc
    install_file_for_user "$user" "$PROJECT_ROOT/config/bash/.bashrc" ".bashrc"

    # Install bash config directory
    install_config_for_user "$user" "$PROJECT_ROOT/config/bash/.bash" ".bash"

    # Add bash completion support (only if not already present)
    if ! grep -q "bash-completion" "$user_home/.bashrc"; then
        cat << 'EOF' >> "$user_home/.bashrc"

# Enable bash-completion if available
if [[ $PS1 && -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi
EOF
        [ "$user" != "root" ] && chown "$user:$user" "$user_home/.bashrc"
        log "Added bash-completion to .bashrc for $user"
    else
        log "bash-completion already configured in .bashrc for $user"
    fi

    # Set bash as default shell for user (use usermod to avoid interactive prompts)
    if command -v usermod >/dev/null 2>&1; then
        usermod -s /bin/bash "$user" 2>/dev/null || true
        log "Set bash as default shell for $user"
    fi
done

# Set bash as default shell for new users
if [ -f /etc/default/useradd ]; then
    sed -i 's|^SHELL=.*|SHELL=/bin/bash|' /etc/default/useradd 2>/dev/null || true
    log "Set bash as default shell for new users"
fi

log "Bash configuration complete for all users."
