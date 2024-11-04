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
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Check if the user is in China (can be improved based on your network checks)
if [[ $(curl -s https://ipinfo.io/country) == "CN" ]]; then
    echo "Detected user in China. Configuring Docker with Alibaba Cloud registry."

    # Import Alibaba Cloud GPG key
    curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/alibaba.gpg

    # Add the Alibaba Cloud Docker repository
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/alibaba.gpg] https://mirrors.aliyun.com/docker-ce/linux/debian/ \
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

# Update package lists
sudo apt-get update

# Install Docker packages
install_package docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
