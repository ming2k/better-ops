#!/bin/bash

PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
source $PROJECT_ROOT/lib/common.sh
source $PROJECT_ROOT/lib/install-package.sh

generate_banner "SETTING BASH"

# Bashrc
# ---------------------
# backup existing configurations
backup_file ~/.bashrc
backup_file ~/.bash_profile

# Install custom bashrc
cp $PROJECT_ROOT/config/bash/.bashrc ~/.bashrc

# Copy bash configuration files
if [ ! -d ~/.bash ]; then
    mkdir -p ~/.bash
fi

# Copy all bash assets
cp -r $PROJECT_ROOT/config/bash/.bash/* ~/.bash/

# Bash completion
# ---------------------
install_package bash-completion
# add bash completion support
cat << 'EOF' >> ~/.bashrc

# Enable bash-completion if available
if [[ $PS1 && -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi
EOF
log "Successfully configured bash-completion."

# bash fzf (only if not already copied)
install_package fzf
if [ ! -f ~/.bash/tools/fzf.bash ]; then
    log "warn" "fzf.bash not found in assets, creating basic configuration"
    mkdir -p ~/.bash/tools
    echo '# FZF configuration will be loaded from system installation' > ~/.bash/tools/fzf.bash
fi
log "Successfully configured fzf."

# Let profile include source the bashrc
source /etc/profile
