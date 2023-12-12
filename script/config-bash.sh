#!/bin/bash

print_with_border "CONFIG BASH"

sudo rm /etc/bash.bashrc
sudo cp $asset_path/bash.bashrc /etc/bash.bashrc

# backup .bashrc
mv ~/.bashrc ~/.bashrc.bak && touch ~/.bashrc

echo "alias ls='ls --color=auto'" >> ~/.bashrc

if [ "$(get_distribution)" = "debian" ]; then
    echo "Tring to insatll \"bash-completion\"..."
    install_package apt bash-completion
fi

cat << EOF >> ~/.bashrc
[[ \$PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion
EOF

log "Finish"
