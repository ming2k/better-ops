#!/bin/bash

print_with_border "SETTING NVIM"

install_package neovim

cp $asset_path/init.lua > ~/.config/nvim/

echo -e "\nexport EDITOR=nvim" >> ~/.bashrc && . ~/.bashrc

