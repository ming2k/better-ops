#!/bin/bash

print_with_border "SETTING SSHD"

wget $PUB_KEY_URL -O ~/.ssh/authorized_keys

log "Already set ssh authorized_keys."

sudo cp $asset_path/sshd_config /etc/ssh/sshd_config

sudo systemctl restart sshd && log "sshd restarted"



