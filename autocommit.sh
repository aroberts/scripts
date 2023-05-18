#!/bin/bash

tgt=$1

usage() {
  echo >&2 "usage: $0 <git-rootdir-name>"
  exit 1
}

[ "$#" -eq 1 ] || usage
[ -d "$tgt/.git" ] || usage

cd "$tgt"
git="/usr/local/bin/git"

if [[ -n $($git status --short) ]]; then
  $git add -A && git commit -m "Autocommit `date`"
else
  echo 'clean'
fi
