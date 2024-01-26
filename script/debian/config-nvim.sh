#!/bin/bash

print_with_border "SETTING VIM"

install_package apt neovim

vimrc_path=/usr/share/nvim/sysinit.vim

sudo echo << EOF >> /etc/profile.d/nvim.sh
alias vi=nvim
alias vim=nvim

export VIM=/usr/share/nvim
export EDITOR=nvim
EOF

sudo rm $vimrc_path
sudo cat $asset_path/sysinit > $vimrc_path
