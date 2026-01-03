#!/usr/bin/env bash

set -euo pipefail

paused="$(dunstctl is-paused || echo false)"
waiting="$(dunstctl count waiting 2>/dev/null | tr -d '\n' || echo 0)"

state="none"
if [[ "$waiting" != "0" ]]; then
  state="notification"
fi

if [[ "$paused" == "true" ]]; then
  if [[ "$state" == "notification" ]]; then
    state="paused-notification"
  else
    state="paused-none"
  fi
fi

printf '{"text":"","alt":"%s","tooltip":"","class":"%s"}\n' "$state" "$state"
