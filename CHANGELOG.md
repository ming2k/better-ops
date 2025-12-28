# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2025-12-29

### Changed

#### Development Environment
- Simplified Dockerfile to minimal base (only Debian Trixie Slim + WORKDIR)
- Removed pre-installed packages from container - all tools now installed via scripts
- Updated container workflow to run as root by default
- Removed `--userns=keep-id` requirement for simpler development setup
- Removed dev-container.sh helper script in favor of direct podman commands
- Container now persists by default with `--name better-ops-dev` (removed `--rm` flag)

#### Installation Scripts
- Added bash and sudo to preflight package installation
- Fixed nvim.sh to use sudo when writing to /usr/local/bin
- Added fuse3 to preflight for AppImage support
- Improved bash.sh to set bash as default shell for current user and new users
- Added automatic shell reload with `exec bash` after bash configuration

#### Documentation
- Restructured DEVELOPMENT.md with "Development Workflow" section
- Updated container usage instructions with clearer commands
- Added container re-entry and removal instructions
- Simplified Dockerfile architecture documentation
- Removed references to removed dev-container.sh script

#### Core Scripts
- Fixed shell validation in main.sh to check BASH_VERSION instead of SHELL variable
- Changed shell validation message from WARN to ERROR for clarity

### Removed
- SELinux `:Z` volume flag (unnecessary for Arch Linux and most setups)
- dev-container.sh script (replaced with direct documentation)
- Pre-installed packages from Dockerfile (git, curl, wget, bash)
- Passwordless sudo configuration from Dockerfile
- Default CMD from Dockerfile (uses base image default)

## [1.0.0] - 2025-09-14

### Added

#### Core System
- Automated installation script with OS detection (Debian 12, Ubuntu)
- Modular library system with logging, utilities, and preflight checks
- Container-based testing environment with Docker/Podman support

#### Bash Environment
- Advanced bash configuration with colored prompts (grey datetime)
- Comprehensive aliases, functions, and completions
- Integrated tools: FZF, GPG, NNN file manager
- Multi-environment support (personal, root, remote)

#### Neovim Setup
- Complete Lua-based configuration with LSP support
- 15+ language-specific configurations
- Plugin ecosystem: LuaSnip, nvim-cmp, Telescope, Treesitter
- Customizable themes and intelligent folding

#### Security & SSH
- Hardened SSH daemon configuration
- Secure client/server setup scripts

