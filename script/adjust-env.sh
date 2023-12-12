#!/bin/bash

# backup bashrc
mv ~/.bashrc ~/.bashrc.bak
touch ~/.bashrc

# app should be installed
if [ "$(get_distribution)" = "debian" ]; then
    install_package apt vim
    install_package apt ranger
fi

echo "alias ls='ls --color=auto'" >> ~/.bashrc
echo "export EDITOR=vim" >> ~/.bashrc
