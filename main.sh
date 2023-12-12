#!/bin/bash

# 检查当前用户是否为 root 用户
if [ "$EUID" -ne 0 ]; then
    echo "Please use root to execute the script."
    exit 1
fi

# 检查当前终端的 SHELL 环境变量
if [ "$SHELL" != "/bin/bash" ]; then
    echo "Please use bash to execute the script."
    exit 1
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

