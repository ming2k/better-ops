#!/bin/bash

rm /etc/bash.bashrc && cp $asset_path/bash.bashrc /etc/bash.bashrc

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

