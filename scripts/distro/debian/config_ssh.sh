#!/bin/bash

print_with_border "SETTING SSHD"

# log "Already set ssh authorized_keys."

sudo cp $ASSET_DIR/sshd_config /etc/ssh/sshd_config

sudo systemctl restart sshd && log "sshd restarted"



