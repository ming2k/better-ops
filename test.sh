#!/bin/bash

# check whether the shell is "bash"
if [ "$SHELL" != "/bin/bash" ]; then
    echo "Please use bash to execute the script."
    return 1
fi

(
    root_path=$(dirname "$(readlink -f "$0")")
    test_path=$root_path/test
    asset_path=$root_path/asset
    script_path=$root_path/script
    lib_path=$root_path/lib

    for file in "$lib_path"/*.sh; do
        if [ -f "$file" ]; then
            . "$file"
        fi
    done

    # . "$test_path"/generate-banner.sh
    . "$script_path"/config-ssh.sh

)

