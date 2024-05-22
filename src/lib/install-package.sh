#!/bin/bash

# 安装软件包
install_package() {
    # 检查是否输入了包管理工具和软件包名称
    if [ -z "$1" ] || [ -z "$2" ]; then
        log "error" "Please specify the package management tool and package name."
        return 1
    fi

    # 检查当前用户是否为 root 用户
    if [ "$EUID" -ne 0 ]; then
        log "error" "Password is asked to install package."
    fi

    case "$1" in
        "apt")
            dpkg -l | grep -q -w "^ii  $2 " && {log "$2 has installed."; return 0}
            sudo apt-get update > /dev/null
            sudo apt-get install -y "$2" > /dev/null
            ;;
        "yum")
            sudo yum makecache > /dev/null
            sudo yum install -y "$2" > /dev/null
            ;;
        "pacman")
            sudo pacman -Syyu > /dev/null
            sudo pacman -S "$2" > /dev/null
            ;;
        *)
            echo "The package management tool is not supported."
            return 1
            ;;
    esac
    log "The repository was updated."

    log "\"$2\" was installed."
}
