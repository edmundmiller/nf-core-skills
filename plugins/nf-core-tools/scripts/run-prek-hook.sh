#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -eq 0 ]; then
  echo "Usage: $0 <hook-id|--all>"
  exit 2
fi

hook="$1"
if [ "${hook}" = "--all" ]; then
  exec prek run --all-files
fi

exec prek run "${hook}" --all-files
