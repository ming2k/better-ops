#!/bin/bash

# check whether the shell is "bash"
if [ "$SHELL" != "/bin/bash" ]; then
    log error "Please use bash to execute the script."
    return 1
fi

(
    root_path=$(dirname "$(readlink -f "$0")")
    asset_path=$root_path/asset
    script_path=$root_path/script
    lib_path=$root_path/lib

    for file in "$lib_path"/*.sh; do
        if [ -f "$file" ]; then
            . "$file"
        fi
    done

    . "$script_path"/config-network.sh
    . "$script_path"/install-pkg.sh
    . "$script_path"/config-bash.sh
    . "$script_path"/config-vim.sh
    . "$script_path"/config-ssh.sh

)

