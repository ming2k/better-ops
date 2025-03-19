#!/bin/bash

get_distribution() {
    local distribution="Unknown"

    # Check for /etc/os-release file
    if [ -f /etc/os-release ]; then
        distribution=$(awk -F= '/^ID=/{gsub(/"/, "", $2); print $2}' /etc/os-release)
    else
        # Try other methods if /etc/os-release is not available
        if [ -f /etc/redhat-release ]; then
            distribution="redhat"
        elif [ -f /etc/debian_version ]; then
            distribution="debian"
        elif [ -f /etc/lsb-release ]; then
            distribution=$(awk -F= '/^DISTRIB_ID=/{gsub(/"/, "", $2); print $2}' /etc/lsb-release)
        elif command -v lsb_release &> /dev/null; then
            distribution=$(lsb_release -si)
        fi
    fi

    echo "$distribution"
}
