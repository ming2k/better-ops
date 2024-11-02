#!/bin/bash

# check if the current shell is running bash and exit if not
if [ "$SHELL" != "/bin/bash" ]; then
    echo -e "[$(date "+%Y-%m-%d %H:%M:%S")] [\e[33mWARN\e[0m] Invalid number of arguments"
    exit 1
fi

# get the parent directory of the current script
parent_dir=$(dirname "$(dirname "$(readlink -f "$0")")")
script_path="$parent_dir/scripts"
lib_path="$parent_dir/lib"
asset_path="$script_path/assets"

# active the library
. $lib_path/log.sh
. $lib_path/get_distribution.sh
. $lib_path/install_package.sh
. $lib_path/generate_banner.sh

DIST_OS=$(get_distribution)

# exec the scripts
debian_script_path="$script_path/distro/debian"
if [ $DIST_OS = "debian" ]; then
    . ${debian_script_path}/preflight.sh
    . ${debian_script_path}/config_network.sh
    . ${debian_script_path}/config_bash.sh
    . ${debian_script_path}/config_ssh.sh
    . ${debian_script_path}/config_nvim.sh
    . ${debian_script_path}/config_docker.sh
fi

source /etc/bash.bashrc