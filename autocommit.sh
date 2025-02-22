#!/bin/bash

# for finding git binary
prefixes=("/usr/local" "/opt/homebrew" "/usr")

tgt=$1

debug() {
  if [ "$DEBUG" != "" ]; then
    echo >&2 "DEBUG: $1"
  fi
}

usage() {
  echo >&2 "usage: $0 <git-rootdir-name>"
  exit 1
}

[ "$#" -eq 1 ] || usage
[ -d "$tgt/.git" ] || usage


# finding git
debug "Finding git binary"
git=
for p in "${prefixes[@]}"; do
  f="$p/bin/git"
  debug "checking $f"
  if [[ -f "$f" ]]; then
    git="$f"
    debug "found $f"
    break
  else
    debug "not found $f"
  fi
done


debug "Entering directory"

cd "$tgt"

debug "Checking git status"

if [[ -n $("$git" status --short) ]]; then
  debug "Running git add" && \
    "$git" add -A && \
    debug "Running git commit" && \
    "$git" commit -m "Autocommit `date`" && \
    debug "Running git push" && \
    "$git" push
else
  debug 'clean'
fi
