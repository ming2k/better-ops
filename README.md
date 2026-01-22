# Better Operations

All operations serve better VPS management, committed to simplicity and efficiency.

## Features

- Advanced Bash Configuration: Custom aliases, functions, completions and so on
- Neovim Setup: Complete configuration with plugins and language support
- SSH Configuration: Secure SSH daemon and client setup


## Supported Distributions

| Distribution | Status |
|--------------|--------|
| Debian 12    | Passed |
| Debian 13    | Passed |

## Quick Start

Clone the project:

```bash
# Debian/Ubuntu
apt install git sudo

# Clone repository
git clone https://github.com/ming2k/better-ops.git && cd better-ops
```

Install:

```bash
# Run complete setup
./bin/main.sh
```

## Configuration

Better-Ops can be customized using environment variables or a configuration file.

### Environment Variables

Customize installation by setting environment variables before running:

```bash
# Timezone configuration
export TIMEZONE="America/New_York"

# Run installation
./bin/main.sh
```

**Note:** Neovim version (v0.11.1) is hardcoded for stability. If you need a different version, modify `lib/setup/nvim.sh` directly.

### Configuration File

Create a configuration file for persistent settings:

```bash
# Create config directory
mkdir -p ~/.config/better-ops

# Copy example configuration
cp config/better-ops.conf.example ~/.config/better-ops/better-ops.conf

# Edit configuration
vim ~/.config/better-ops/better-ops.conf
```

See [config/better-ops.conf.example](config/better-ops.conf.example) for all available options.

## Testing

Better-Ops includes comprehensive testing tools:

### Unit Tests

Run unit tests to verify core functionality:

```bash
./tests/run-tests.sh
```

### Code Quality (ShellCheck)

Lint all shell scripts for best practices:

```bash
./scripts/lint.sh
```

Note: Requires ShellCheck to be installed:
```bash
# Debian/Ubuntu
sudo apt-get install shellcheck

# Fedora/RHEL
sudo dnf install ShellCheck
```

### Integration Tests

Run full installation in a container:

```bash
./tests/integration/test-full-install.sh
```

Note: Requires Podman or Docker to be installed.

## Documentation

- [API Documentation](docs/API.md) - Complete function reference
- [Troubleshooting Guide](docs/TROUBLESHOOTING.md) - Common issues and solutions
- [Development Guide](DEVELOPMENT.md) - Development setup and contributing

## Troubleshooting

If you encounter issues:

1. Check the [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
2. Run tests: `./tests/run-tests.sh`
3. Verify installation in a clean container: `./tests/integration/test-full-install.sh`
4. Enable debug mode: `bash -x ./bin/main.sh`

Common issues:

- **Package installation fails**: Check internet connection and disk space
- **Neovim download fails**: Verify internet access to GitHub
- **Checksum verification fails**: Retry download or verify checksum manually
- **Permission denied**: Run with `sudo ./bin/main.sh`

For detailed solutions, see [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md).

## Security

Better-Ops follows security best practices:

- ✓ All downloads are verified with SHA256 checksums
- ✓ Backup files have restrictive permissions (600)
- ✓ No command injection vulnerabilities
- ✓ Proper error handling with `set -euo pipefail`
- ✓ All variable expansions are properly quoted

## Development

For development setup, testing, and contributing, see [DEVELOPMENT.md](DEVELOPMENT.md).
