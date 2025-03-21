#!/bin/bash

PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
source $PROJECT_ROOT/lib/banner-generator.sh
source $PROJECT_ROOT/lib/log.sh
source $PROJECT_ROOT/lib/install_package.sh

generate_banner "EXEC PREFLIGHT CHECK"

install_package sudo build-essential rsync curl wget git
