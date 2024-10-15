#!/bin/bash

####################
# PRESET KEY VALUE #
####################

PUB_KEY_URL=https://github.com/ming2k.keys

# check if the current shell is running bash and exit if not
if [ "$SHELL" != "/bin/bash" ]; then
    echo -e "[$(date "+%Y-%m-%d %H:%M:%S")] [\e[33mWARN\e[0m] Invalid number of arguments"
    exit 1
fi

# get the current file absolute path
script_path=$(dirname "$(readlink -f "$0")")
asset_path="$script_path/asset"

# active the library
lib_path="$script_path/lib"
. $lib_path/log.sh
. $lib_path/get_distribution.sh
. $lib_path/install_package.sh
. $lib_path/generate_banner.sh

DIST_OS=$(get_distribution)

# exec the scripts
debian_script_path="$script_path/distro/debian"
if [ $DIST_OS = "debian" ]; then
    . ${debian_script_path}/preflight.sh
    . ${debian_script_path}/config-network.sh
    . ${debian_script_path}/config-bash.sh
    . ${debian_script_path}/config-ssh.sh
    . ${debian_script_path}/config-nvim.sh
    . ${debian_script_path}/config-docker.sh
fi

source /etc/bash.bashrc
