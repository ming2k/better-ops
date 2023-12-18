#!/bin/bash

print_with_border "CONFIG VIM"


# app should be installed
if [ "$(get_distribution)" = "debian" ]; then
    install_package apt vim
fi

sudo rm /etc/vimrc
sudo cp $asset_path/vimrc /etc/vimrc

sudo echo -e "\nexport EDITOR=vim" >> /etc/bash.bashrc

log "Finish"