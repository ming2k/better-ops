#!/bin/bash

print_with_border "SETTING NVIM"

sudo add-apt-repository ppa:neovim-ppa/unstable -y && sudo apt update
install_package neovim

git clone https://github.com/ming2k/nvim-config.git ~/.config/nvim

echo -e "\nexport EDITOR=nvim" >> ~/.bashrc && . ~/.bashrc
