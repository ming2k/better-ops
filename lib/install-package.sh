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

    echo "Trying to update source..."
    case "$1" in
        "apt")
            sudo apt-get update
            ;;
        "yum")
            sudo yum makecache
            ;;
        *)
            echo "The package management tool is not supported."
            return 1
            ;;
    esac

    echo "Trying to insatll \"$2\"..."
    # 安装软件包
    case "$1" in
        "apt")
            sudo apt-get install -y "$2"
            ;;
        "yum")
            sudo yum install -y "$2"
            ;;
    esac

    # 返回状态码
    return $?
}
