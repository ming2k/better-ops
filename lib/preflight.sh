#!/bin/bash

PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
source $PROJECT_ROOT/lib/banner-generator.sh
source $PROJECT_ROOT/lib/log.sh
source $PROJECT_ROOT/lib/install-package.sh

generate_banner "EXEC PREFLIGHT CHECK"

install_package sudo
install_package build-essential rsync curl wget git man-db
# For AppImage
install_package fuse3 libfuse3-3
