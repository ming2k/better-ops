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

## Core Scripts

### Entry Point: `bin/main.sh`

The main installation script that:
1. Validates the shell is bash
2. Detects the distribution using `get_distribution()`
3. Runs preflight checks (installs essential packages)
4. Executes setup modules based on the detected OS

Key features:
- Sources library modules dynamically
- Distribution-specific installation paths (Debian/Ubuntu)
- Modular setup execution

### Library Modules: `lib/`

**`common.sh`** - Shared functionality:
- `create_config_dir()` - Creates `~/.config/better-ops`
- `backup_file()` - Backs up files with timestamps
- `is_container()` - Detects container environments
- `check_command()` - Validates command availability
- `validate_file_content()` - Content validation
- `get_system_info()` - Generates system information

**`preflight.sh`** - Pre-installation:
- Installs essential packages: sudo, build-essential, rsync, curl, wget, git, man-db
- Installs fuse3/libfuse3-3 for AppImage support

**`install-package.sh`** - Package management wrapper:
- Abstraction layer for apt/yum/pacman
- Automatic distribution detection

**`log.sh`** - Logging:
- Color-coded log levels (info, warn, error)
- Timestamp prefixes

**`banner-generator.sh`** - Visual feedback:
- Generates ASCII banners for setup stages

**`get-distribution.sh`** - OS detection:
- Identifies Debian, Ubuntu, and other distributions

### Setup Modules: `lib/setup/`

Each module follows a standard pattern:
1. Source common libraries
2. Generate banner
3. Backup existing configurations
4. Install packages
5. Copy configuration files
6. Validate installation

**Example flow (`bash.sh`):**
```bash
source lib/common.sh
generate_banner "SETTING BASH"
backup_file ~/.bashrc
install_package bash-completion
cp config/bash/.bashrc ~/.bashrc
cp -r config/bash/.bash/* ~/.bash/
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

#### Testing Idempotency:

```bash
# Run setup twice - should not error or duplicate
./bin/main.sh
./bin/main.sh  # Should skip already-configured items
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

### Adding New Setup Modules

Create `lib/setup/newmodule.sh`:

```bash
#!/bin/bash

PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
source $PROJECT_ROOT/lib/common.sh
source $PROJECT_ROOT/lib/install-package.sh

generate_banner "SETTING NEW MODULE"

# Backup existing configs
backup_file ~/.newmodulerc

# Install packages
install_package package-name

# Copy configurations
cp $PROJECT_ROOT/config/newmodule/.newmodulerc ~/.newmodulerc

log "Successfully configured new module."
```

Then add to `bin/main.sh`:
```bash
if [ "$DIST_OS" = "debian" ]; then
    . ${PROJECT_ROOT}/lib/setup/newmodule.sh
fi
```

## Dockerfile Architecture

The Dockerfile is truly minimal:

```dockerfile
FROM debian:trixie-slim          # Bare Debian base
WORKDIR /better-ops              # Project mount point
```

**Design principles:**
- **Bare minimum**: Only base image and working directory
- **POSIX-compliant**: Uses base image's default shell
- **Scripts handle everything**: All tools installed by setup scripts
- **No COPY**: Source code mounted at runtime
- **Fast iteration**: Code changes don't require rebuild

