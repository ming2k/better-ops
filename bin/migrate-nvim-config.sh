#!/bin/bash

mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"

# bash list of directories to copy
PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
source $PROJECT_ROOT/lib/banner-generator.sh
source $PROJECT_ROOT/lib/log.sh
source $PROJECT_ROOT/lib/get-distribution.sh

# exec mv host $HOME/.config/nvim "after  ftplugin  init.lua  lua  queries" assets/nvim
awk '{gsub(/require\("plugin_loader"\)/, "-- require(\"plugin_loader\")"); print}' "$HOME/.config/nvim/init.lua" > "$PROJECT_ROOT/assets/nvim/init.lua"
cp -r "$HOME/.config/nvim/lua" "$PROJECT_ROOT/assets/nvim/lua"
cp -r "$HOME/.config/nvim/queries" "$PROJECT_ROOT/assets/nvim/queries"
cp -r "$HOME/.config/nvim/ftplugin" "$PROJECT_ROOT/assets/nvim/ftplugin"
cp -r "$HOME/.config/nvim/after" "$PROJECT_ROOT/assets/nvim/after"


