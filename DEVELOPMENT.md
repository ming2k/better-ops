# Development Guide

This guide covers the architecture, development workflow, and testing for better-ops.

## Project Structure

```
better-ops/
├── bin/
│   └── main.sh              # Main installation entry point
├── lib/
│   ├── banner-generator.sh  # ASCII banner generation
│   ├── common.sh            # Shared functions and variables
│   ├── get-distribution.sh  # OS detection utilities
│   ├── install-package.sh   # Package management wrapper
│   ├── log.sh              # Logging utilities
│   ├── preflight.sh        # Pre-installation checks
│   └── setup/              # Setup modules
│       ├── bash.sh         # Bash configuration
│       ├── network.sh      # Network settings
│       ├── nvim.sh         # Neovim setup
│       └── ssh.sh          # SSH configuration
├── config/
│   └── bash/               # Bash configuration files
│       ├── .bashrc         # Main bashrc
│       └── .bash/          # Additional bash assets
└── Dockerfile              # Development environment
```

## Key Development Concepts

### Idempotency

**All setup scripts MUST be idempotent** - safe to run multiple times without causing errors or duplicating configurations.

#### Idempotency Rules:

1. **File Appends**: Always check if content exists before appending
   ```bash
   # BAD - appends every time
   echo "export PATH=..." >> ~/.bashrc

   # GOOD - check first
   if ! grep -q "export PATH=" ~/.bashrc; then
       echo "export PATH=..." >> ~/.bashrc
   fi
   ```

2. **File Copies**: Use proper directory structure, don't append to `.bashrc`
   ```bash
   # BAD - modifies .bashrc directly
   echo "export EDITOR=nvim" >> ~/.bashrc

   # GOOD - use modular structure
   echo "export EDITOR=nvim" > ~/.bash/exports/editor.bash
   ```

3. **Package Installation**: Use `install_package()` which checks if already installed
   ```bash
   install_package package-name  # Automatically skips if installed
   ```

4. **Version Checks**: Check versions before reinstalling
   ```bash
   if [ -f /usr/local/bin/nvim ]; then
       CURRENT=$(/usr/local/bin/nvim --version | awk '{print $2}')
       if [ "$CURRENT" == "$TARGET_VERSION" ]; then
           log "Already installed"
           return 0
       fi
   fi
   ```

5. **Backups**: Use timestamped backups to avoid overwriting
   ```bash
   # GOOD - timestamped backup
   BACKUP="$FILE.bak.$(date +%Y%m%d-%H%M%S)"
   mv "$FILE" "$BACKUP"
   ```

### Backup Strategy

All setup modules use `backup_file()` from `lib/common.sh`:
- Creates timestamped backups: `file.better-ops-backup.YYYYMMDD-HHMMSS`
- Tracks backups in `~/.config/better-ops/backups.list`
- Prevents accidental data loss

### Distribution Detection

The `get_distribution()` function in `lib/get-distribution.sh`:
- Reads `/etc/os-release`
- Returns normalized distribution name (debian, ubuntu, etc.)
- Allows conditional setup paths in `bin/main.sh`

### Package Installation

Use `install_package()` from `lib/install-package.sh`:
- Handles different package managers automatically
- Logs installation status
- Skips already-installed packages

### Logging Best Practices

```bash
log "info message"              # [INFO] with timestamp
log "warn" "warning message"    # [WARN] in yellow
log "error" "error message"     # [ERROR] in red
```

## Development Workflow

### Container Development Environment

Use containers to develop and test better-ops in an isolated Debian environment without affecting your host system.

#### Prerequisites

- Podman or Docker installed

#### Usage

**Build the development image:**
```bash
podman build -t better-ops:dev .
```

**Run the container:**
```bash
podman run -it --name better-ops-dev -v ./:/better-ops better-ops:dev
```

Note: Container runs as root by default, allowing scripts to install packages.

**Re-enter an existing container:**
```bash
podman start -ai better-ops-dev
```

**Remove the container when done:**
```bash
podman rm better-ops-dev
```

**Inside the container:**
```bash
# Verify running as root
whoami  # Should output: root

# Test the full installation
./bin/main.sh

# Test individual setup modules
source lib/setup/bash.sh
source lib/setup/nvim.sh

# Verify configurations
cat ~/.bashrc
ls -la ~/.bash/

# Exit when done
exit
```

#### Command Flags

- `--name better-ops-dev`: Named container for easy reference
- `-v ./:/better-ops`: Live-mounts current directory (no rebuild needed)
- `-it`: Interactive terminal
- Running as root: Allows package installation without pre-installed sudo

#### Benefits

- **Minimal base**: Truly bare Debian image, scripts install everything
- **Fast iteration**: Changes are instant, no image rebuild required
- **Isolated environment**: Test in clean Debian without affecting host
- **Reproducible**: Consistent Debian base for all developers

#### Security Considerations

**Container Development Risks:**

While containers provide isolation, running development containers carries security risks you should be aware of:

1. **Running as Root**
   - Our setup runs containers as root for simplicity (to install packages without pre-configuring sudo)
   - Root in container = elevated privileges that could potentially affect the host
   - If compromised, root access may facilitate container escape attacks

2. **Container Escape Risks**
   - Container escape vulnerabilities exist in container runtimes (Docker, Podman)
   - Even with rootless containers, escape risks are not eliminated completely
   - Kernel vulnerabilities or misconfigurations can be exploited
   - Volume mounts (`-v`) can be attack vectors if not carefully managed

3. **Recommendations**

   **Use Rootless Containers (Recommended):**
   ```bash
   # Run Podman in rootless mode (default for non-root users)
   podman run -it --name better-ops-dev -v ./:/better-ops better-ops:dev
   ```

   Rootless containers:
   - Run without root privileges on the host
   - Provide additional security layer through user namespace isolation
   - Limit potential damage from container escape
   - Are the default mode for Podman when run as non-root user

   **Additional Best Practices:**
   - Only mount necessary directories (avoid mounting entire filesystem)
   - Don't run untrusted code in development containers
   - Keep container runtime (Podman/Docker) updated
   - Use separate containers for different projects
   - Don't store sensitive credentials in containers or mounted volumes
   - Consider using read-only mounts when possible: `-v ./:/better-ops:ro`

4. **Trade-offs**
   - **Convenience vs Security**: Running as root simplifies package installation but increases risk
   - **Development vs Production**: These risks are more acceptable in local development than production
   - **Isolation vs Access**: Volume mounts enable development workflow but create potential attack surface

**Note:** This setup prioritizes development convenience. For production deployments or handling sensitive data, implement additional security hardening measures.

