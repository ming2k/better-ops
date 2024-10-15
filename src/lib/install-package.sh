#!/bin/bash

# Function to install packages
install_package() {
    # Check if at least two arguments are provided (package manager and at least one package)
    if [ $# -lt 2 ]; then
        log "error" "Please specify the package management tool and at least one package name."
        return 1
    fi

    # Extract the package manager from the first argument
    package_manager=$1
    shift  # Remove the first argument (package manager)

    # Install packages based on the specified package manager
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
        *)
            # Error message for unsupported package managers
            log "error" "The package management tool is not supported."
            return 1
            ;;
    esac
}

# Usage examples:
# install_package apt package1 package2 package3
# or
# install_package yum package1 package2 package3
# or
# install_package pacman package1 package2 package3