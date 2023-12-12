#!/bin/bash

sudo rm /etc/vimrc && sudo cp $asset_path/vimrc /etc/vimrc
echo "export EDITOR=vim" >> ~/.bashrc
