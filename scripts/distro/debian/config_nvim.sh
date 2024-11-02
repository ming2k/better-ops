#!/bin/bash

# 假设 print_with_border 和 install_package 函数已经在其他地方定义

print_with_border "SETTING NVIM"

# 安装 Neovim
install_package neovim

# 设置路径
asset_path="$(dirname "$0")/../assets/nvim_config"
nvim_config_dir="$HOME/.config/nvim"

# 创建 Neovim 配置目录（如果不存在）
mkdir -p "$nvim_config_dir"

# 复制所有配置文件
if [ -d "$asset_path" ]; then
    cp -R "$asset_path"/* "$nvim_config_dir/"
    echo "Neovim configuration files copied successfully."
else
    echo "Error: Neovim configuration directory not found at $asset_path"
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