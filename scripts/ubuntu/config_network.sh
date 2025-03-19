#!/bin/bash

source $LIB_DIR/init-path.sh
source $LIB_DIR/generate-banner.sh

generate-banner "SETTING NETWORK"

hostname=$(hostname)
file_path=/etc/hosts

if ! grep -q "$hostname" "$file_path"; then
    # 如果不存在则添加字符串
    sudo echo -e "\n127.0.0.1 $(hostname)" >> /etc/hosts
    log "Added localhost-hostname map."
else
    log "localhost-hostname already exists in $file_path"
fi
