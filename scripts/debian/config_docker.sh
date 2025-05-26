#!/bin/bash

PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
source $PROJECT_ROOT/lib/banner-generator.sh
source $PROJECT_ROOT/lib/log.sh
source $PROJECT_ROOT/lib/install_package.sh

generate_banner "SETTING DOCKER ON UBUNTU"

# Function to install packages
install_package() {
  sudo apt-get install -y "$@"
}

# Remove conflicting packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
  sudo apt-get remove -y $pkg
done

# Update package lists and install basic dependencies
sudo apt-get update
install_package ca-certificates curl

# Add Docker's official GPG key:
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package lists again
sudo apt-get update

# Install Docker packages
install_package docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Check if the user is in China and configure mirrors if needed
if [[ $(curl -s https://ipinfo.io/country) == "CN" ]]; then
  log "Detected user in China. Configuring Docker with mirror registries."

  # Configure Docker to use mirror registries
  sudo mkdir -p /etc/docker
  echo '{
    "registry-mirrors": [ "https://docker.m.daocloud.io", "https://docker.jianmuhub.com", "https://huecker.io", "https://dockerhub.timeweb.cloud", "https://dockerhub1.beget.com", "https://noohub.ru"]
  }' | sudo tee /etc/docker/daemon.json > /dev/null

  # Restart Docker service to apply changes
  sudo systemctl restart docker
fi

generate_banner "DOCKER INSTALLATION COMPLETE"
