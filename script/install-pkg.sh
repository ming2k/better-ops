#!/bin/bash

# app should be installed
if [ "$(get_distribution)" = "debian" ]; then
    install_package apt vim
    install_package apt ranger
fi