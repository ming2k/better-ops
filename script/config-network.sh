#!/bin/bash

print_with_border "CONFIG NETWORK"

hostname=$(hostname)
file_path=/etc/hosts

if ! grep -q "$hostname" "$file_path"; then
    # 如果不存在则添加字符串
    sudo echo -e "\n127.0.0.1 $(hostname)" >> /etc/hosts
    echo "Added localhost-hostname map."
else
    echo "localhost-hostname already exists in $file_path"
fi