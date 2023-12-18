#!/bin/bash

print_with_border "CONFIG NETWORK"

sudo echo -e "\n127.0.0.1 $(hostname)" >> /etc/hosts