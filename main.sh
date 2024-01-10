#!/bin/bash

# check whether the shell is "bash"
if [ "$SHELL" != "/bin/bash" ]; then
    log error "Please use bash to execute the script."
    return 1
fi

(
    root_path=$(dirname "$(readlink -f "$0")")
    asset_path=$root_path/asset
    lib_path=$root_path/lib

    script_path=$root_path/script
    debian_script_path=$script_path/debian

    for file in "$lib_path"/*.sh; do
        if [ -f "$file" ]; then
            . "$file"
        fi
    done

    . "$script_path"/release.sh

)

