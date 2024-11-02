#!/bin/bash

print_with_border "SETTING VIM"

install_package vim
log "Vim installation completed."

vimrc_path=/etc/vim/vimrc
sudo rm $vimrc_path
# Add the os-related config
sudo echo -e "\nruntime! debian.vim" > $vimrc_path
sudo cat $asset_path/vimrc >> $vimrc_path
log "Successfully configured vim."

sudo echo -e "\nexport EDITOR=vim" >> /etc/bash.bashrc
