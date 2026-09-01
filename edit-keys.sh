#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
source_file="$script_dir/kumauta.keys.list"
output_file="$script_dir/kumauta.keys"
editor=${VISUAL:-${EDITOR:-vi}}

"$editor" "$source_file"

tmp_file=$(mktemp "$output_file.tmp.XXXXXX")
trap 'rm -f "$tmp_file"' EXIT HUP INT TERM

awk '
{
  line = $0
  sub(/[[:space:]]*#.*/, "", line)
  sub(/^[[:space:]]+/, "", line)
  sub(/[[:space:]]+$/, "", line)

  if (line == "")
    next

  key = substr(line, 9)
  if (substr(line, 1, 8) != "nodekey:" ||
      length(key) != 64 || key !~ /^[0-9a-f]+$/) {
    printf "Invalid Tailcat public key at line %d: %s\n", NR, $0 > "/dev/stderr"
    invalid = 1
    next
  }

  if (seen[line]++) {
    printf "Duplicate Tailcat public key at line %d: %s\n", NR, line > "/dev/stderr"
    invalid = 1
    next
  }

  keys[++count] = line
}
END {
  if (invalid)
    exit 1
  if (count == 0) {
    print "No Tailcat public keys found" > "/dev/stderr"
    exit 1
  }
  for (i = 1; i <= count; i++)
    printf "%s%s", (i == 1 ? "" : ","), keys[i]
  print ""
}
' "$source_file" > "$tmp_file"

mv "$tmp_file" "$output_file"
trap - EXIT HUP INT TERM

printf 'Updated %s\n' "$output_file"
