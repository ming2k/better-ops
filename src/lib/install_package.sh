#!/bin/bash

# Function to install packages
install_package() {
    # Check if at least one package is specified
    if [ $# -lt 1 ]; then
        log "error" "Please specify at least one package name."
        return 1
    fi

    # Determine package manager based on DIST_OS
    case "$DIST_OS" in
        "ubuntu"|"debian")
            package_manager="apt"
            ;;
        "centos"|"rhel"|"fedora")
            package_manager="yum"
            ;;
        "arch"|"manjaro")
            package_manager="pacman"
            ;;
        *)
            log "error" "Unsupported distribution: $DIST_OS"
            return 1
            ;;
    esac

    # Install packages based on the determined package manager
    case "$package_manager" in
        "apt")
            # Update repository for apt
            sudo apt-get update > /dev/null
            log "The repository was updated."
            # Install each specified package
            for package in "$@"; do
                if dpkg -l | grep -q -w "^ii  $package "; then
                    log "$package is already installed."
                else
                    sudo apt-get install -y "$package" > /dev/null
                    log "\"$package\" was installed."
                fi
            done
            ;;
        "yum")
            # Update repository for yum
            sudo yum makecache > /dev/null
            log "The repository was updated."
            # Install each specified package
            for package in "$@"; do
                if rpm -q "$package" > /dev/null 2>&1; then
                    log "$package is already installed."
                else
                    sudo yum install -y "$package" > /dev/null
                    log "\"$package\" was installed."
                fi
            done
            ;;
        "pacman")
            # Update repository for pacman
            sudo pacman -Syyu --noconfirm > /dev/null
            log "The repository was updated."
            # Install each specified package
            for package in "$@"; do
                if pacman -Qi "$package" > /dev/null 2>&1; then
                    log "$package is already installed."
                else
                    sudo pacman -S --noconfirm "$package" > /dev/null
                    log "\"$package\" was installed."
                fi
            done
            ;;
    esac
}

# Usage example:
# install_package package1 package2 package3