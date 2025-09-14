# Development Guide

## Container Testing with Interactive Mode

The `scripts/interactive-test.sh` script provides an easy way to test better-ops configurations in a containerized environment without affecting your host system.

### Prerequisites

- Docker or Podman installed on your system
- The interactive test script will automatically detect which container runtime is available

### Usage

1. **Run the interactive test container:**
   ```bash
   ./scripts/interactive-test.sh
   ```

2. **What the script does:**
   - Detects available container runtime (Docker or Podman)
   - Builds a test container using the project's Dockerfile
   - Starts an interactive container with:
     - Current project directory mounted at `/better-ops`
     - Clean Debian 12 environment
     - Test user with sudo privileges
     - Interactive bash shell

3. **Inside the container:**
   ```bash
   # Test the main installation script
   ./bin/main.sh

   # Test individual components
   source lib/setup/bash.sh
   source lib/setup/nvim.sh

   # Verify configurations
   cat ~/.bashrc
   ls -la ~/.bash/
   ```

4. **Exit the container:**
   ```bash
   exit
   ```

### Container Environment Details

- **Base Image:** Debian 12 Slim
- **Test User:** `testuser` with sudo privileges
- **Working Directory:** `/better-ops` (mounted from host)
- **Packages:** git, sudo, curl, wget, bash

### Testing Workflow

1. Make changes to configuration files
2. Run `./scripts/interactive-test.sh`
3. Test your changes in the clean container environment
4. Exit and repeat as needed

### Benefits

- **Isolated Testing:** No risk to your host system
- **Reproducible Environment:** Consistent Debian 12 base
- **Quick Iteration:** Fast container startup for testing
- **Real-time Changes:** Host directory is mounted, so changes are immediately available

This approach ensures your configurations work correctly in a clean environment before deploying to production systems.