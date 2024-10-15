#!/bin/bash

print_with_border "SETTING NVIM"

install_package neovim

git clone -b offline https://github.com/ming2k/nvim-config.git ~/.config/nvim

sudo rm $vimrc_path
sudo cat $asset_path/sysinit.vim > $vimrc_path

echo -e "\nexport EDITOR=nvim" >> ~/.bashrc && . ~/.bashrc