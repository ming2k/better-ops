#!/bin/bash
set -euo pipefail

# Initialize project root if not already set
if [ -z "${PROJECT_ROOT:-}" ]; then
    SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
    source "$SCRIPT_DIR/../init.sh"
fi

source "$PROJECT_ROOT/lib/common.sh"

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
