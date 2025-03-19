#!/bin/bash

source $LIB_DIR/init-path.sh
source $LIB_DIR/generate-banner.sh
source $LIB_DIR/install_package.sh

generate-banner "SETTING NVIM"

# 安装 Neovim
install_package neovim

# 设置路径
nvim_config_dir="$HOME/.config/nvim"

# 创建 Neovim 配置目录（如果不存在）
mkdir -p "$nvim_config_dir"

# 复制所有配置文件
if [ -d "$ASSET_DIR" ]; then
    cp -R "$ASSET_DIR"/* "$nvim_config_dir/"
    echo "Neovim configuration files copied successfully."
else
    echo "Error: Neovim configuration directory not found at $ASSET_DIR"
    exit 1
fi

# 设置 EDITOR 环境变量
if ! grep -q "export EDITOR=nvim" ~/.bashrc; then
    echo -e "\nexport EDITOR=nvim" >> ~/.bashrc
    echo "EDITOR environment variable set to nvim in ~/.bashrc"
else
    echo "EDITOR environment variable already set to nvim in ~/.bashrc"
fi

# 重新加载 .bashrc
source ~/.bashrc

echo "Neovim setup completed."