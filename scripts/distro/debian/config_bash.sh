#!/bin/bash

# DON'T MDODIFY THE HOME BASHRC, LEFT THE CHOICE TO USER 

print_with_border "SETTING BASH"

# backup .bashrc and .bash_profile
mv ~/.bashrc ~/.bashrc.bak && cp $asset_path/bash_config/.bashrc ~/.bashrc
mv ~/.bash_profile ~/.bash_profile.bak && cp $asset_path/bash_config/.bash_profile ~/.bash_profile

# bash complete
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
if [ ! -d ~/.bashrc.d ]; then
    mkdir ~/.bashrc.d
fi

# bash fzf
install_package fzf
cp $asset_path/bash_config/fzf.bash ~/.bashrc.d/fzf.bash
cat >> ~/.bashrc <<'EOF'

source ~/.bashrc.d/fzf.bash
EOF
log "Successfully configured fzf."

. ~/.bash_profile
log "Already souced '.bash_profile'."