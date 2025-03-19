#!/bin/bash

PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
source $PROJECT_ROOT/lib/banner-generator.sh
source $PROJECT_ROOT/lib/log.sh
source $PROJECT_ROOT/lib/install_package.sh

generate_banner "SETTING NVIM"

# 安装 Neovim
install_package neovim

# 设置路径
nvim_config_dir="$HOME/.config/nvim"

# 创建 Neovim 配置目录（如果不存在）
mkdir -p "$nvim_config_dir"

# 复制所有配置文件
if [ -d "$PROJECT_ROOT/assets/nvim_config" ]; then
    cp -R "$PROJECT_ROOT/assets/nvim_config/"* "$nvim_config_dir/"
    log "Neovim configuration files copied successfully."
else
    log "error" "Error: Neovim configuration directory not found at $PROJECT_ROOT/assets/nvim_config"
    exit 1
fi

# 设置 EDITOR 环境变量
if ! grep -q "export EDITOR=nvim" ~/.bashrc; then
    echo -e "\nexport EDITOR=nvim" >> ~/.bashrc
    log "EDITOR environment variable set to nvim in ~/.bashrc"
else
    log "EDITOR environment variable already set to nvim in ~/.bashrc"
fi

# 重新加载 .bashrc
source ~/.bashrc

log "Neovim setup completed."