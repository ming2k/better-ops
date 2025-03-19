#!/bin/bash

source $LIB_DIR/init-path.sh
source $LIB_DIR/generate-banner.sh
source $LIB_DIR/install_package.sh

generate-banner "EXEC PREFLIGHT CHECK"

install_package sudo build-essential rsync curl wget git
