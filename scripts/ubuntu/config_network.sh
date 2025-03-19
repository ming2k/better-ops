#!/bin/bash

PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
source $PROJECT_ROOT/lib/banner-generator.sh
source $PROJECT_ROOT/lib/log.sh

generate_banner "SETTING NETWORK"

hostname=$(hostname)
file_path=/etc/hosts

if ! grep -q "$hostname" "$file_path"; then
    # 如果不存在则添加字符串
    sudo echo -e "\n127.0.0.1 $(hostname)" >> /etc/hosts
    log "Added localhost-hostname map."
else
    log "localhost-hostname already exists in $file_path"
fi
