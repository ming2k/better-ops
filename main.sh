#!/bin/bash

# 检查当前终端的 SHELL 环境变量
if [ "$SHELL" != "/bin/bash" ]; then
    echo "Please use bash to execute the script."
    return 1
fi

(
    root_path=$(dirname "$(readlink -f "$0")")
    asset_path=$(dirname "$(readlink -f "$0")")/asset
    script_path=$root_path/script
    lib_path=$root_path/lib

    for file in "$lib_path"/*.sh; do
        if [ -f "$file" ]; then
            . "$file"
        fi
    done

    . "$script_path"/install-pkg.sh
    . "$script_path"/config-bash.sh
    . "$script_path"/config-vim.sh

)

