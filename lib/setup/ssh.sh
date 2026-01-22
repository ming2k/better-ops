#!/bin/bash
set -euo pipefail

# Initialize project root if not already set
if [ -z "${PROJECT_ROOT:-}" ]; then
    SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
    source "$SCRIPT_DIR/../init.sh"
fi

source "$PROJECT_ROOT/lib/banner-generator.sh"
source "$PROJECT_ROOT/lib/log.sh"

generate_banner "SETTING SSH"

# Try to restart SSH service, checking both sshd and ssh service names
# First check sshd service
if systemctl list-unit-files sshd.service > /dev/null 2>&1; then
  # sshd service exists, try to restart it
  if sudo systemctl restart sshd.service; then
    log "info" "sshd restarted"
  else
    log "error" "sshd restart failed"
  fi
else
  # sshd not found, try ssh service instead
  log "info" "sshd service file does not exist, trying ssh service."
  if systemctl list-unit-files ssh.service > /dev/null 2>&1; then
    # ssh service exists, try to restart it
    if sudo systemctl restart ssh.service; then
      log "info" "ssh restarted"
    else
      log "error" "ssh restart failed"
    fi
  else
    log "info" "ssh service file does not exist."
  fi
fi
