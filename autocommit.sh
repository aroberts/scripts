#!/bin/bash

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

debug "Entering directory"

cd "$tgt"
git="/usr/local/bin/git"

debug "Checking git status"

if [[ -n $($git status --short) ]]; then
  debug "Running git add" && $git add -A && debug "Running git commit" && $git commit -m "Autocommit `date`" && debug "Running git push" && $git push
else
  debug 'clean'
fi
