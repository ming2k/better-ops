#!/bin/bash

if [ "$(get_distribution)" = "debian" ]; then
    . ${debian_script_path}/config-network.sh
    . ${debian_script_path}/install-pkg.sh
    . ${debian_script_path}/config-bash.sh
    . ${debian_script_path}/config-vim.sh
    . ${debian_script_path}/config-ssh.sh
fi

source /etc/bash.bashrc
