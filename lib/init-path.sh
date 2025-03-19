#!/bin/bash

# Define common paths used throughout the project
PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
ASSETS_DIR="$PROJECT_ROOT/assets"
SCRIPTS_DIR="$PROJECT_ROOT/scripts"
LIB_DIR="$PROJECT_ROOT/lib"
BIN_DIR="$PROJECT_ROOT/bin" 