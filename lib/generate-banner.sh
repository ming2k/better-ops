#!/bin/bash

print_with_border() {
  str="$1"
  cols=64
  padding=$((($cols-2-${#str})/2))
  
  echo
  echo
  echo
  # printf '+'; printf -- '-%.0s' {1..$(($cols-2))}; printf '+'; echo
  printf '+'; printf -- '-%.0s' $(seq 1 $(($cols-2))); printf '+'; echo
  printf '|'; printf "%${padding}s"; printf "$str"; printf "%${padding}s"; printf '|'; echo
  printf '+'; printf -- '-%.0s' $(seq 1 $(($cols-2))); printf '+'; echo
}