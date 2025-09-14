#!/bin/bash

PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
source $PROJECT_ROOT/lib/banner-generator.sh
source $PROJECT_ROOT/lib/log.sh

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
