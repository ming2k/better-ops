#!/bin/bash

# DON'T MDODIFY THE HOME BASHRC, LEFT THE CHOICE TO USER 

print_with_border "SETTING BASH"

sudo mv /etc/bash.bashrc /etc/bash.bashrc.bak
sudo cp $asset_path/bash.bashrc /etc/bash.bashrc

# backup .bashrc
mv ~/.bashrc ~/.bashrc.bak && touch ~/.bashrc

# bash complete
install_package apt bash-completion
sudo cat << EOF >> /etc/bash.bashrc

[[ \$PS1 && -f /usr/share/bash-completion/bash_completion ]] &&
    . /usr/share/bash-completion/bash_completion
EOF
log "Successfully configured bash-completion."

# bash fzf
install_package apt fzf
echo -e "\nsource /usr/share/doc/fzf/examples/key-bindings.bash" >> /etc/bash.bashrc
log "Successfully configured fzf."
