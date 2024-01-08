#!/bin/bash

# DON'T MDODIFY THE HOME BASHRC, LEFT THE CHOICE TO USER 

print_with_border "SETTING BASH"

sudo mv /etc/bash.bashrc /etc/bash.bashrc.bak
sudo cp $asset_path/bash.bashrc /etc/bash.bashrc

# backup .bashrc
mv ~/.bashrc ~/.bashrc.bak && touch ~/.bashrc

if [ "$(get_distribution)" = "debian" ]; then
    echo "Tring to insatll \"bash-completion\"..."
    install_package apt bash-completion
fi

sudo cat << EOF >> /etc/bash.bashrc

[[ \$PS1 && -f /usr/share/bash-completion/bash_completion ]] &&
    . /usr/share/bash-completion/bash_completion
EOF

log "Finish"
