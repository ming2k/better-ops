#!/bin/bash

# 检查是否使用 bash 运行脚本
if [ "$SHELL" != "/bin/bash" ]; then
    echo "error: Please use bash to execute the script."
    exit 1
fi

# 获取脚本所在的目录
root_path=$(dirname "$(readlink -f "$0")")
script_path="$root_path/script"
lib_path="$root_path/lib"
asset_path="$root_path/asset"

# 导入 lib_path 目录下的所有 .sh 文件
for file in "$lib_path"/*.sh; do
    if [ -f "$file" ]; then
        . "$file"
    else
        echo "warning: No .sh files found in $lib_path"
    fi
done


# 导入 release.sh 脚本
if [ -f "$script_path/release.sh" ]; then
    . "$script_path/release.sh"
else
    echo "error: $script_path/release.sh not found"
    exit 1
fi