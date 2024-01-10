#!/bin/bash

if [ "$(get_distribution)" = "debian" ]; then
    . ${debian_script_path}/config-network.sh
    . ${debian_script_path}/debian/install-pkg.sh
    . ${debian_script_path}/debian/config-bash.sh
    . ${debian_script_path}/debian/config-vim.sh
    . ${debian_script_path}/debian/config-ssh.sh
fi
