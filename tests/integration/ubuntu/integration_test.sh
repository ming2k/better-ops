#!/bin/bash

# Get the project root directory and verify it exists
PROJECT_ROOT=$(dirname "$(dirname "$(dirname "$(dirname "$(readlink -f "$0")")")")")

if [ ! -d "$PROJECT_ROOT" ]; then
    echo "Error: Could not find project root directory at $PROJECT_ROOT"
    exit 1
fi

# Verify and source required library files
LIB_FILES=("banner-generator.sh" "log.sh")
for lib in "${LIB_FILES[@]}"; do
    lib_path="$PROJECT_ROOT/lib/$lib"
    if [ ! -f "$lib_path" ]; then
        echo "Error: Required library file not found: $lib_path"
        exit 1
    fi
    source "$lib_path"
done

# Handle Ctrl+C gracefully
cleanup() {
    log "Received interrupt signal. Cleaning up..."
    if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
    if [ -n "$CONTAINER_ENGINE" ] && [ -n "$IMAGE_NAME" ]; then
        $CONTAINER_ENGINE rm -f $(${CONTAINER_ENGINE} ps -q -f ancestor=$IMAGE_NAME) 2>/dev/null || true
        $CONTAINER_ENGINE rmi -f $IMAGE_NAME 2>/dev/null || true
    fi
    log "Cleanup complete. Exiting."
    exit 1
}

trap cleanup INT TERM

generate_banner "RUNNING UBUNTU INTEGRATION TEST"

# Check if Docker or Podman is available
if command -v docker &> /dev/null; then
    CONTAINER_ENGINE="docker"
    log "Using Docker for integration test"
elif command -v podman &> /dev/null; then
    CONTAINER_ENGINE="podman"
    log "Using Podman for integration test"
else
    log "error" "Neither Docker nor Podman is installed. Please install one of them to run the integration test."
    exit 1
fi

# Create a temporary Dockerfile
TEMP_DIR=$(mktemp -d)
DOCKERFILE="$TEMP_DIR/Dockerfile"

# Create Dockerfile content - using EOF without quotes to allow variable substitution
# and using the correct sudoers syntax
cat > "$DOCKERFILE" << EOF
FROM ubuntu:latest

# Install required packages for the test
RUN apt-get update && apt-get install -y \\
    sudo \\
    bash \\
    git \\
    curl \\
    wget \\
    ca-certificates \\
    && rm -rf /var/lib/apt/lists/*

# Create a test user
RUN useradd -m -s /bin/bash testuser
RUN echo "testuser ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/testuser

# Set working directory
WORKDIR /app

# Copy the project files
COPY . .

# Make scripts executable before switching user
RUN find /app -type f -name "*.sh" -exec chmod +x {} +

# Switch to the test user
USER testuser

# Entry point
CMD ["/bin/bash", "-c", "cd /app && bin/main.sh && echo 'Test completed successfully' || echo 'Test failed'"]
EOF

log "Building test container..."

# Build the container image
IMAGE_NAME="ubuntu-config-test-image"
$CONTAINER_ENGINE build -t $IMAGE_NAME -f "$DOCKERFILE" "$PROJECT_ROOT"

if [ $? -ne 0 ]; then
    log "error" "Failed to build the test container image."
    rm -rf "$TEMP_DIR"
    exit 1
fi

log "Running test container..."

# Run the container with proper signal handling
$CONTAINER_ENGINE run --rm --init $IMAGE_NAME

# Clean up
rm -rf "$TEMP_DIR"
log "Test completed. Container has been removed."