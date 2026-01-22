#!/bin/bash
set -euo pipefail

#######################################
# Log a message with timestamp and optional level indicator
# Arguments:
#   $1 - (Optional) Log level: error, warn, info, success
#        If only one argument, treated as message with INFO level
#   $2 - Message to log (if level is provided)
# Outputs:
#   Formatted log message with timestamp and colored level to stdout
# Examples:
#   log "Starting installation"
#   log "info" "Configuration loaded"
#   log "warn" "Configuration file not found, using defaults"
#   log "error" "Failed to connect to server"
#   log "success" "Installation completed"
#######################################
log() {
  local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
  local level=""
  local message=""

  if [ $# -eq 1 ]; then
    level="\e[32mINFO\e[0m"
    message="$1"
  elif [ $# -eq 2 ]; then
    case "$1" in
      error)
        level="\e[31mERROR\e[0m"  # 红色表示
        message="$2"
        ;;
      warn)
        level="\e[33mWARN\e[0m"  # 黄色表示
        message="$2"
        ;;
      info)
        level="\e[32mINFO\e[0m"  # 绿色表示
        message="$2"
        ;;
      success)
        level="\e[32mSUCCESS\e[0m"  # 绿色表示
        message="$2"
        ;;
      *)
        echo "Invalid log level: $1"
        return
        ;;
    esac
  else
    echo -e "[$timestamp] [\e[33mWARN\e[0m] Invalid number of arguments"
    return
  fi

  echo -e "[$timestamp] [$level] $message"
}