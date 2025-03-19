#!/bin/bash

source $LIB_DIR/init-path.sh
source $LIB_DIR/generate-banner.sh

generate-banner "SETTING SSH"

# Try to restart SSH service, checking both sshd and ssh service names
# First check sshd service
if systemctl list-unit-files sshd.service > /dev/null 2>&1; then
  # sshd service exists, try to restart it
  if sudo systemctl restart sshd.service; then
    log "sshd restarted"
  else
    log "sshd restart failed"
  fi
else
  # sshd not found, try ssh service instead
  log "sshd service file does not exist, trying ssh service."
  if systemctl list-unit-files ssh.service > /dev/null 2>&1; then
    # ssh service exists, try to restart it
    if sudo systemctl restart ssh.service; then
      log "ssh restarted"
    else
      log "ssh restart failed"
    fi
  else
    log "ssh service file does not exist."
  fi
fi
