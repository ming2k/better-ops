#!/bin/bash

PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
source $PROJECT_ROOT/lib/banner-generator.sh
source $PROJECT_ROOT/lib/log.sh
source $PROJECT_ROOT/lib/install-package.sh

generate_banner "SETTING BASH"

# Bashrc
# ---------------------
# backup .bashrc and .bash_profile
[ -f ~/.bashrc ] && mv ~/.bashrc ~/.bashrc.bak
[ -f ~/.bash_profile ] && mv ~/.bash_profile ~/.bash_profile.bak

cp $PROJECT_ROOT/assets/bash_config/.bash ~/.bashrc

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

# if bashrc.d does not exist, create it
if [ ! -d ~/.bash ]; then
    mkdir ~/.bash
fi

# bash fzf
install_package fzf
cp $PROJECT_ROOT/assets/bash_config/.bash/fzf.bash ~/.bash/fzf.bash
cat >> ~/.bashrc <<'EOF'

source ~/.bash/fzf.bash
EOF
log "Successfully configured fzf."

# Let profile include source the bashrc
source /etc/profile
