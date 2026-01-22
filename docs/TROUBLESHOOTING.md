# Better-Ops Troubleshooting Guide

This guide helps you resolve common issues when using better-ops.

## Table of Contents

- [Installation Issues](#installation-issues)
- [Package Installation Errors](#package-installation-errors)
- [Neovim Download Issues](#neovim-download-issues)
- [Permission Issues](#permission-issues)
- [Configuration Issues](#configuration-issues)
- [Backup and Recovery](#backup-and-recovery)
- [Container Issues](#container-issues)

---

## Installation Issues

### "This script requires bash"

**Problem:** The script is being run with a shell other than bash.

**Solution:**
```bash
# Run with bash explicitly
bash ./bin/main.sh

# Or make sure your shebang uses bash
#!/bin/bash
```

---

### "Failed to update package repository"

**Problem:** The package repository update failed.

**Possible Causes:**
1. No internet connection
2. Disk space full
3. Repository servers down
4. DNS issues

**Solutions:**

1. Check internet connection:
```bash
ping -c 3 8.8.8.8
```

2. Check disk space:
```bash
df -h
```

3. Clear package cache:
```bash
# Debian/Ubuntu
sudo apt-get clean
sudo apt-get update

# CentOS/RHEL/Fedora
sudo yum clean all
sudo yum makecache
```

4. Check DNS resolution:
```bash
# Add to /etc/resolv.conf if needed
nameserver 8.8.8.8
nameserver 8.8.4.4
```

---

## Package Installation Errors

### "Failed to install [package]"

**Problem:** A specific package failed to install.

**Solutions:**

1. Try installing the package manually:
```bash
sudo apt-get install [package]
```

2. Check for package name differences:
   - Some packages have different names on different distributions
   - Search for the package: `apt-cache search [keyword]`

3. Check for conflicting packages:
```bash
sudo apt-get install -f  # Fix broken dependencies
```

4. Check available disk space:
```bash
df -h /var
```

---

### "Elevated privileges required"

**Problem:** Script needs root access but neither running as root nor sudo available.

**Solutions:**

1. Run as root:
```bash
su -
./bin/main.sh
```

2. Install sudo first (as root):
```bash
apt-get install sudo
usermod -aG sudo your_username
```

3. Use the script with sudo:
```bash
sudo ./bin/main.sh
```

---

## Neovim Download Issues

### "Failed to download Neovim"

**Problem:** Unable to download Neovim from GitHub.

**Possible Causes:**
1. No internet connection
2. GitHub rate limiting
3. Firewall blocking downloads
4. Proxy issues

**Solutions:**

1. Check internet connection:
```bash
wget -q --spider https://github.com
echo $?  # Should return 0
```

2. Check GitHub rate limits:
   - Wait a few minutes and try again
   - GitHub may rate-limit anonymous requests

3. Download manually and place in correct location:
```bash
# Download from: https://github.com/neovim/neovim/releases
wget https://github.com/neovim/neovim/releases/download/v0.11.1/nvim-linux-x86_64.appimage
sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
sudo chmod u+x /usr/local/bin/nvim
```

4. If behind a proxy, set proxy environment variables:
```bash
export http_proxy="http://proxy.example.com:8080"
export https_proxy="http://proxy.example.com:8080"
./bin/main.sh
```

---

### "Checksum verification failed"

**Problem:** Downloaded Neovim binary checksum doesn't match expected value.

**Possible Causes:**
1. Corrupted download
2. Man-in-the-middle attack
3. Wrong checksum in configuration

**Solutions:**

1. Delete the corrupted file and retry:
```bash
sudo rm -f /usr/local/bin/nvim.tmp
./bin/main.sh
```

2. Verify the checksum manually:
```bash
# Download the file
wget https://github.com/neovim/neovim/releases/download/v0.11.1/nvim-linux-x86_64.appimage

# Check the actual checksum
sha256sum nvim-linux-x86_64.appimage

# Compare with the release page:
# https://github.com/neovim/neovim/releases/tag/v0.11.1
```

3. If you need a different Neovim version:
   - Edit `lib/setup/nvim.sh` directly
   - Update `NVIM_VERSION`, `NVIM_SHA256`, and verify the `URL`
   - Get checksums from: https://github.com/neovim/neovim/releases

---

## Permission Issues

### "Permission denied" errors

**Problem:** Script cannot write to system directories.

**Solutions:**

1. Run with sudo:
```bash
sudo ./bin/main.sh
```

2. Check file permissions:
```bash
ls -la /usr/local/bin/
```

3. If SELinux is enabled, check context:
```bash
# Check if SELinux is enforcing
getenforce

# Temporarily disable (not recommended for production)
sudo setenforce 0

# Or set correct context
sudo chcon -t bin_t /usr/local/bin/nvim
```

---

### "Cannot write to directory"

**Problem:** User doesn't have write permissions for a directory.

**Solutions:**

1. Check directory ownership:
```bash
ls -ld /path/to/directory
```

2. Fix ownership (as root):
```bash
sudo chown username:username /path/to/directory
```

3. Check parent directory permissions:
```bash
ls -ld /path/to
```

---

## Configuration Issues

### "Invalid timezone"

**Problem:** Specified timezone doesn't exist.

**Solutions:**

1. List available timezones:
```bash
timedatectl list-timezones
```

2. Search for your timezone:
```bash
timedatectl list-timezones | grep America
timedatectl list-timezones | grep Asia
```

3. Set a valid timezone:
```bash
export TIMEZONE="America/New_York"
./bin/main.sh
```

---

### Configuration not loading

**Problem:** Custom configuration file is not being loaded.

**Solutions:**

1. Check file location:
```bash
ls -la ~/.config/better-ops/better-ops.conf
```

2. Ensure correct format (bash syntax):
```bash
# Good
BETTER_OPS_NVIM_VERSION="v0.11.1"

# Bad (no export needed in config file)
export BETTER_OPS_NVIM_VERSION="v0.11.1"
```

3. Check for syntax errors:
```bash
bash -n ~/.config/better-ops/better-ops.conf
```

4. Load configuration manually for testing:
```bash
source ~/.config/better-ops/better-ops.conf
echo $BETTER_OPS_NVIM_VERSION
```

---

## Backup and Recovery

### Restore from backup

**Problem:** Need to restore a backed-up file.

**Solution:**

1. List all backups:
```bash
cat ~/.config/better-ops/backups.list
```

2. Find the backup you need:
```bash
ls -lat ~/.bashrc.better-ops-backup.*
```

3. Restore the backup:
```bash
cp ~/.bashrc.better-ops-backup.20240122-103045 ~/.bashrc
```

4. Verify the restored file:
```bash
cat ~/.bashrc
```

---

### Remove all backups

**Problem:** Backup files taking up too much space.

**Solution:**

```bash
# List backup size
du -sh ~/.*.better-ops-backup.*

# Remove old backups (older than 30 days)
find ~ -name "*.better-ops-backup.*" -mtime +30 -delete

# Remove all backups (careful!)
find ~ -name "*.better-ops-backup.*" -delete

# Clear the backup list
> ~/.config/better-ops/backups.list
```

---

## Container Issues

### "Neither podman nor docker is installed"

**Problem:** Integration tests require a container runtime.

**Solutions:**

1. Install Podman (recommended):
```bash
# Debian/Ubuntu
sudo apt-get install podman

# Fedora
sudo dnf install podman
```

2. Install Docker:
```bash
# Debian/Ubuntu
sudo apt-get install docker.io
sudo systemctl start docker
sudo usermod -aG docker $USER
# Log out and back in for group changes
```

---

### "Failed to build test container"

**Problem:** Container build failed.

**Solutions:**

1. Check Dockerfile exists:
```bash
ls -l Dockerfile
```

2. Check for errors in Dockerfile:
```bash
cat Dockerfile
```

3. Build with verbose output:
```bash
podman build --no-cache -t better-ops:test .
```

4. Check disk space:
```bash
df -h
```

---

### Container tests fail but manual installation works

**Problem:** Integration tests fail but the script works outside containers.

**Possible Causes:**
1. Volume mount issues
2. SELinux blocking container access
3. Network issues in container

**Solutions:**

1. Check volume mount with `:Z` flag for SELinux:
```bash
podman run --rm -v ./:/better-ops:Z better-ops:test /better-ops/bin/main.sh
```

2. Run container with more privileges for debugging:
```bash
podman run --rm --privileged -v ./:/better-ops:Z better-ops:test bash
# Then manually run: /better-ops/bin/main.sh
```

3. Check container networking:
```bash
podman run --rm better-ops:test ping -c 3 8.8.8.8
```

---

## General Debugging

### Enable verbose output

Add debugging to any script:

```bash
# Add at the top of the script
set -x  # Print each command before executing

# Or run with bash -x
bash -x ./bin/main.sh
```

### Check logs

View recent log messages:

```bash
# If using systemd journal
journalctl -xe

# Check system logs
tail -f /var/log/syslog  # Debian/Ubuntu
tail -f /var/log/messages  # CentOS/RHEL
```

---

## Getting Help

If you continue to have issues:

1. Check the [API Documentation](API.md) for function details
2. Review the [README](../README.md) for usage examples
3. Run tests to verify installation:
   ```bash
   ./tests/run-tests.sh
   ```
4. Run ShellCheck for code quality:
   ```bash
   ./scripts/lint.sh
   ```
5. Report issues at: https://github.com/your-repo/better-ops/issues

Include in your report:
- Operating system and version
- Error messages (full output)
- Steps to reproduce
- What you've tried already
