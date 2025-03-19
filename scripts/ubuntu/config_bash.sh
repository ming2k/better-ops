#!/bin/bash

source $LIB_DIR/init-path.sh
source $LIB_DIR/generate-banner.sh
source $LIB_DIR/install_package.sh

generate-banner "SETTING BASH"

# Bashrc
# ---------------------
# backup .bashrc and .bash_profile
if [ -f ~/.bashrc ]; 
    then mv ~/.bashrc ~/.bashrc.bak
fi

cp $ASSET_DIR/bash_config/.bashrc ~/.bashrc

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
cp $ASSET_DIR/bash_config/.bash/fzf.bash ~/.bash/fzf.bash
cat >> ~/.bashrc <<'EOF'

source ~/.bash/fzf.bash
EOF
log "Successfully configured fzf."

# Let profile include source the bashrc
source /etc/profile
