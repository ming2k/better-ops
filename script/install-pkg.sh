#!/bin/bash

print_with_border "INSTALL PACKAGE"

# app should be installed
if [ "$(get_distribution)" = "debian" ]; then
    install_package apt sudo
    install_package apt vim
    # Optinal package
    install_package apt ranger
fi

log "Finish"
