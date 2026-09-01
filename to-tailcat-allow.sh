#!/usr/bin/env sh
set -eu

# Convert a commented, one-key-per-line file into the comma-separated value
# expected by tailcat's --allow option. The source may be a path, URL, or "-"
# for standard input.
keys_source=${1:-kumauta.keys}

case "$keys_source" in
  http://*|https://*) curl -fsSL "$keys_source" ;;
  -) cat ;;
  *) cat "$keys_source" ;;
esac |
  sed \
    -e 's/[[:space:]]*#.*$//' \
    -e 's/^[[:space:]]*//' \
    -e 's/[[:space:]]*$//' \
    -e '/^$/d' |
  paste -sd, -
