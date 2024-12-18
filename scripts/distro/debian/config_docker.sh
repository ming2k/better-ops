#!/bin/bash

print_with_border "SETTING DOCKER"

# Function to install packages
install_package() {
    sudo apt-get install -y "$@"
}

# Install dependencies
install_package ca-certificates curl gnupg

# Add Docker's official GPG key:
sudo install -m 0755 -d /etc/apt/keyrings

# Check if the user is in China
if [[ $(curl -s https://ipinfo.io/country) == "CN" ]]; then
    echo "Detected user in China. Configuring Docker with Alibaba Cloud registry."

    # Import Alibaba Cloud GPG key
    sudo curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/debian/gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/alibaba.gpg

    # Add the Alibaba Cloud Docker repository
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/alibaba.gpg] https://mirrors.aliyun.com/docker-ce/linux/debian/ \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Configure Docker to use Alibaba Cloud registry mirror
    sudo mkdir -p /etc/docker
    echo '{
      "registry-mirrors": [ "https://docker.m.daocloud.io", "https://docker.jianmuhub.com", "https://huecker.io", "https://dockerhub.timeweb.cloud", "https://dockerhub1.beget.com", "https://noohub.ru"]
    }' | sudo tee /etc/docker/daemon.json > /dev/null

    # Restart Docker service to apply changes
    sudo systemctl restart docker
else
    echo "Using Docker's official repository."
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
fi

# Update package lists
sudo apt-get update

# Install Docker packages
install_package docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
