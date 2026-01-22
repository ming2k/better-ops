#!/bin/bash
set -euo pipefail

# Integration test for better-ops full installation

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_ROOT=$(dirname "$(dirname "$SCRIPT_DIR")")

echo "================================"
echo "Better-Ops Integration Test"
echo "================================"
echo ""

# Determine container command (prefer podman, fall back to docker)
if command -v podman &>/dev/null; then
    CONTAINER_CMD="podman"
elif command -v docker &>/dev/null; then
    CONTAINER_CMD="docker"
else
    echo "ERROR: Neither podman nor docker is installed"
    echo "Install podman or docker to run integration tests"
    exit 1
fi

echo "Using container runtime: $CONTAINER_CMD"
echo ""

# Check if Dockerfile exists
if [ ! -f "$PROJECT_ROOT/Dockerfile" ]; then
    echo "ERROR: Dockerfile not found at $PROJECT_ROOT/Dockerfile"
    exit 1
fi

# Build test container
echo "Building test container..."
if ! "$CONTAINER_CMD" build -t better-ops:test "$PROJECT_ROOT"; then
    echo "ERROR: Failed to build test container"
    exit 1
fi
echo "✓ Test container built successfully"
echo ""

# Run installation
echo "Running installation in container..."
if ! "$CONTAINER_CMD" run --rm -v "$PROJECT_ROOT:/better-ops:Z" better-ops:test /better-ops/bin/main.sh; then
    echo "ERROR: Installation failed"
    exit 1
fi
echo "✓ Installation completed successfully"
echo ""

# Verify installation
echo "Verifying installation..."
VERIFY_FAILED=0

# Check if .bashrc exists
if ! "$CONTAINER_CMD" run --rm -v "$PROJECT_ROOT:/better-ops:Z" better-ops:test bash -c '[ -f /root/.bashrc ]'; then
    echo "✗ .bashrc not found"
    ((VERIFY_FAILED++))
else
    echo "✓ .bashrc exists"
fi

# Check if nvim is installed
if ! "$CONTAINER_CMD" run --rm -v "$PROJECT_ROOT:/better-ops:Z" better-ops:test bash -c '[ -f /usr/local/bin/nvim ]'; then
    echo "✗ nvim not found at /usr/local/bin/nvim"
    ((VERIFY_FAILED++))
else
    echo "✓ nvim is installed"
fi

# Check if nvim runs and shows version
if ! "$CONTAINER_CMD" run --rm -v "$PROJECT_ROOT:/better-ops:Z" better-ops:test bash -c '/usr/local/bin/nvim --version' >/dev/null 2>&1; then
    echo "✗ nvim does not execute properly"
    ((VERIFY_FAILED++))
else
    echo "✓ nvim executes successfully"
fi

# Check if nvim config exists
if ! "$CONTAINER_CMD" run --rm -v "$PROJECT_ROOT:/better-ops:Z" better-ops:test bash -c '[ -d /root/.config/nvim ]'; then
    echo "✗ nvim config directory not found"
    ((VERIFY_FAILED++))
else
    echo "✓ nvim config directory exists"
fi

echo ""
echo "================================"
echo "Integration Test Summary"
echo "================================"

if [ $VERIFY_FAILED -eq 0 ]; then
    echo "All integration tests passed!"
    exit 0
else
    echo "$VERIFY_FAILED verification checks failed"
    exit 1
fi
