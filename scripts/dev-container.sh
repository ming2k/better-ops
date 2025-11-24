#!/bin/bash

# Simple interactive container testing for better-ops

# Detect container runtime
if command -v podman >/dev/null 2>&1; then
    CONTAINER_CMD="podman"
elif command -v docker >/dev/null 2>&1; then
    CONTAINER_CMD="docker"
else
    echo "Error: Neither Docker nor Podman found"
    exit 1
fi

echo "Using $CONTAINER_CMD for container operations..."

echo "Building test container..."
$CONTAINER_CMD build -t better-ops:test .

echo "Starting interactive container..."
$CONTAINER_CMD run --rm -it \
    --name better-ops-interactive \
    -v "$(pwd):/better-ops" \
    better-ops:test /bin/bash