#!/bin/bash

print_with_border "SETTING VIM"

# app should be installed
if [ "$(get_distribution)" = "debian" ]; then
    install_package apt vim
    vimrc_path=/etc/vim/vimrc
    sudo rm $vimrc_path
    # Add the os-related config
    sudo cat 'runtime! debian.vim' > $vimrc_path
    sudo cat $asset_path/vimrc > $vimrc_path

    sudo echo -e "\nexport EDITOR=vim" > /etc/bash.bashrc

    log "Finish"
fi

# app should be installed
if [ "$(get_distribution)" = "arch" ]; then
    install_package pacman vim
    vimrc_path=/etc/vimrc
    sudo rm $vimrc_path
    # Add the os-related config
    sudo cat 'runtime! archlinux.vim' > $vimrc_path
    sudo cat $asset_path/vimrc > $vimrc_path

    sudo echo -e "\nexport EDITOR=vim" > /etc/bash.bashrc

    log "Finish"
fi
