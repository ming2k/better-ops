#!/bin/bash

PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
source $PROJECT_ROOT/lib/common.sh

generate_banner "SETTING NETWORK"

hostname=$(hostname)
file_path=/etc/hosts

if ! grep -q "$hostname" "$file_path"; then
    # Add hostname mapping to hosts file
    echo -e "\n127.0.0.1 $(hostname)" | sudo tee -a /etc/hosts > /dev/null
    log "Added localhost-hostname map."
else
    log "localhost-hostname already exists in $file_path"
fi
