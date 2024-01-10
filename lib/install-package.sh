#!/bin/bash

# 安装软件包
install_package() {
    # 检查是否输入了包管理工具和软件包名称
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Please specify the package management tool and package name."
        return 1
    fi

    # 检查当前用户是否为 root 用户
    if [ "$EUID" -ne 0 ]; then
        log "Password is asked to install package."
    fi

    case "$1" in
        "apt")
            sudo apt-get update > /dev/null
            ;;
        "yum")
            sudo yum makecache > /dev/null
            ;;
        "pacman")
            sudo pacman -Syyu > /dev/null
            ;;
        *)
            echo "The package management tool is not supported."
            return 1
            ;;
    esac
    log "The repository was updated."

    # 安装软件包
    case "$1" in
        "apt")
            sudo apt-get install -y "$2" > /dev/null
            ;;
        "yum")
            sudo yum install -y "$2" > /dev/null
            ;;
        "pacman")
            sudo pacman -S "$2" > /dev/null
            ;;
    esac
    log "\"$2\"... was installed."
}
