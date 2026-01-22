# Better-Ops API Documentation

This document describes all public functions available in the better-ops library files.

## Table of Contents

- [Common Functions (lib/common.sh)](#common-functions)
- [Logging Functions (lib/log.sh)](#logging-functions)
- [Package Management (lib/install-package.sh)](#package-management)
- [Distribution Detection (lib/get-distribution.sh)](#distribution-detection)
- [Banner Generation (lib/banner-generator.sh)](#banner-generation)

---

## Common Functions

Source: `lib/common.sh`

### create_config_dir()

Creates the better-ops configuration directory if it doesn't exist.

**Arguments:** None

**Returns:** 0 on success

**Example:**
```bash
create_config_dir
```

---

### backup_file(file_path)

Backs up an existing file with a timestamp.

**Parameters:**
- `file_path` - Path to the file to backup

**Returns:** 0 on success

**Example:**
```bash
backup_file "/etc/hosts"
backup_file "$HOME/.bashrc"
```

**Notes:**
- Backup format: `filename.better-ops-backup.YYYYMMDD-HHMMSS`
- Backup is recorded in `~/.config/better-ops/backups.list`
- Backup files are created with restrictive permissions (600)

---

### backup_file_for_user(user, file_relative)

Backs up a file for a specific user.

**Parameters:**
- `user` - Username
- `file_relative` - File path relative to user's home directory

**Returns:** 0 on success

**Example:**
```bash
backup_file_for_user "alice" ".bashrc"
backup_file_for_user "root" ".bash_profile"
```

---

### get_user_home(user)

Gets the home directory for a given user.

**Parameters:**
- `user` - Username

**Outputs:** Home directory path to stdout

**Returns:** 0 on success

**Example:**
```bash
user_home=$(get_user_home "root")  # Returns "/root"
user_home=$(get_user_home "alice") # Returns "/home/alice"
```

---

### get_target_users()

Gets list of target users for configuration installation.

Returns the current user and the original user if running via sudo.

**Arguments:** None

**Outputs:** Newline-separated list of unique usernames to stdout

**Example:**
```bash
for user in $(get_target_users); do
    echo "Installing for $user"
done
```

---

### for_each_target_user(callback_function, [args...])

Executes a callback function for each target user.

**Parameters:**
- `callback_function` - Name of function to call for each user
- `args...` - Additional arguments to pass to the callback

**Example:**
```bash
install_config_for_user() {
    local user="$1"
    echo "Installing for $user"
}

for_each_target_user install_config_for_user
```

---

### validate_writable_dir(dir, [description])

Validates that a directory exists and is writable.

**Parameters:**
- `dir` - Directory path to validate
- `description` - (Optional) Description for error messages

**Returns:**
- 0 if directory exists and is writable
- 1 if directory doesn't exist or is not writable

**Example:**
```bash
if validate_writable_dir "/tmp" "temporary directory"; then
    echo "Directory is valid"
fi
```

---

### check_command(command, [required])

Validates that a command exists and is executable.

**Parameters:**
- `command` - Command name to check
- `required` - (Optional) "true" or "false" (default: "false")

**Returns:**
- 0 if command exists
- 1 if command doesn't exist

**Example:**
```bash
check_command "git" "true"  # Required command
check_command "vim" "false" # Optional command
```

---

### validate_file_content(file, pattern, [description])

Validates that a file exists and contains expected content.

**Parameters:**
- `file` - File path to check
- `pattern` - Pattern to search for (grep compatible)
- `description` - (Optional) Description of content for messages

**Returns:**
- 0 if file exists and contains pattern
- 1 otherwise

**Example:**
```bash
validate_file_content "$HOME/.bashrc" "export EDITOR" "editor setting"
```

---

### install_config_for_user(user, source_dir, dest_relative)

Installs a configuration directory for a specific user.

**Parameters:**
- `user` - Username
- `source_dir` - Source directory path
- `dest_relative` - Destination path relative to user's home

**Returns:**
- 0 on success
- 1 if source directory doesn't exist

**Example:**
```bash
install_config_for_user "alice" "$PROJECT_ROOT/config/nvim" ".config/nvim"
```

---

### install_file_for_user(user, source_file, dest_relative)

Installs a single file for a specific user.

**Parameters:**
- `user` - Username
- `source_file` - Source file path
- `dest_relative` - Destination path relative to user's home

**Returns:**
- 0 on success
- 1 if source file doesn't exist

**Example:**
```bash
install_file_for_user "alice" "$PROJECT_ROOT/config/.bashrc" ".bashrc"
```

---

## Logging Functions

Source: `lib/log.sh`

### log([level], message)

Logs a message with timestamp and optional level indicator.

**Parameters:**
- `level` - (Optional) One of: `error`, `warn`, `info`, `success`
- `message` - The message to log

**Outputs:** Formatted log message with timestamp and colored level

**Example:**
```bash
log "Starting installation"
log "info" "Configuration loaded"
log "warn" "Configuration file not found, using defaults"
log "error" "Failed to connect to server"
log "success" "Installation completed"
```

**Output Format:**
```
[2024-01-22 10:30:45] [INFO] Starting installation
[2024-01-22 10:30:46] [WARN] Configuration file not found
```

---

## Package Management

Source: `lib/install-package.sh`

### install_package(packages...)

Installs one or more packages using the system package manager.

Automatically detects the appropriate package manager based on the distribution.

**Supported Package Managers:**
- `apt-get` (Debian/Ubuntu)
- `yum` (CentOS/RHEL/Fedora)
- `pacman` (Arch/Manjaro)

**Parameters:**
- `packages...` - One or more package names to install

**Returns:**
- 0 if all packages installed successfully or already installed
- 1 if any package failed to install

**Example:**
```bash
install_package bash sudo
install_package git curl wget
```

**Notes:**
- Automatically updates package repository before installing
- Skips packages that are already installed
- Provides a summary of installed, skipped, and failed packages
- Uses sudo automatically if not running as root

---

## Distribution Detection

Source: `lib/get-distribution.sh`

### get_distribution()

Detects and returns the current Linux distribution.

**Arguments:** None

**Outputs:** Distribution name to stdout (lowercase)

**Possible Values:**
- `debian`
- `ubuntu`
- `centos`
- `rhel`
- `fedora`
- `arch`
- `manjaro`
- `Unknown`

**Example:**
```bash
DIST=$(get_distribution)
if [ "$DIST" = "debian" ]; then
    echo "Running on Debian"
fi
```

---

## Banner Generation

Source: `lib/banner-generator.sh`

### generate_banner(text)

Generates and displays a formatted banner with the given text.

**Parameters:**
- `text` - Text to display in the banner

**Outputs:** Formatted banner to stdout

**Example:**
```bash
generate_banner "INSTALLING PACKAGES"
```

**Output:**
```
+--------------------------------------------------------------+
|                    INSTALLING PACKAGES                       |
+--------------------------------------------------------------+
```

---

## Environment Variables

Better-ops supports the following environment variables for configuration:

### Timezone Configuration

- `TIMEZONE` - System timezone (default: `Asia/Shanghai`)

### Example

```bash
export TIMEZONE="America/New_York"
./bin/main.sh
```

**Note:** Neovim version (v0.11.1) is hardcoded in `lib/setup/nvim.sh` for stability. If you need a different version, modify the script directly.

---

## Configuration File

You can create a configuration file at `~/.config/better-ops/better-ops.conf` to set environment variables.

See `config/better-ops.conf.example` for a template.

---

## Error Handling

All scripts use `set -euo pipefail` for robust error handling:

- `set -e` - Exit immediately if a command fails
- `set -u` - Treat unset variables as errors
- `set -o pipefail` - Fail on any error in a pipeline

This ensures that errors are not silently ignored.

---

## Return Codes

Functions follow standard Unix conventions:

- `0` - Success
- `1` - General error
- Other non-zero values - Specific errors (documented per function)

Always check return codes when calling functions:

```bash
if install_package git; then
    log "success" "Git installed"
else
    log "error" "Failed to install git"
    exit 1
fi
```
