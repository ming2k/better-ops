#!/bin/bash

if [ "$(get_distribution)" = "debian" ]; then
    echo "Tring to insatll \"bash-completion\"..."
    install_package apt bash-completion
fi

cat << EOF >> ~/.bashrc
[[ \$PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion
EOF
