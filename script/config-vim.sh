#!/bin/bash

print_with_border "CONFIG VIM"

sudo rm /etc/vimrc
sudo cp $asset_path/vimrc /etc/vimrc

echo "export EDITOR=vim" >> ~/.bashrc

log "Finish"