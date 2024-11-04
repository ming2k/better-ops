#!/bin/bash

print_with_border "SETTING DOCKER"

# Install dependencies
install_package ca-certificates curl

# Add Docker's official GPG key:
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Check if the user is in China (can be improved based on your network checks)
if [[ $(curl -s https://ipinfo.io/country) == "CN" ]]; then
    echo "Detected user in China. Configuring Docker with Alibaba Cloud registry."
    
    # Add the Alibaba Cloud Docker registry instead of Docker Hub
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://mirrors.aliyun.com/docker-ce/linux/debian/ \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Optional: Configure Docker to use the Alibaba Cloud registry
    sudo mkdir -p /etc/docker
    echo '{
      "registry-mirrors": ["https://<your-alibaba-cloud-mirror>"]
    }' | sudo tee /etc/docker/daemon.json > /dev/null

    # Restart Docker service to apply changes
    sudo systemctl restart docker
else
    echo "Using Docker's official repository."
    
    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
fi

# Install Docker packages
install_package docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
