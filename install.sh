#!/bin/sh


install() # src, target
{
  src=$1
  dst=$2
  full_source="$PWD/$src"
  if [ -e $dst ]; then
    if [ ! -L $dst ]; then
      echo "WARNING: $dst exists but is not a symlink."
    elif [[ "$full_source" != `readlink "$dst"` ]]; then
      echo "WARNING: $dst exists but is a symlink to another file."
    fi
  else
    echo "Creating $dst"
    ln -s "$full_source" "$dst"
  fi
}

# make sure we're installing from the right directory
cd `dirname $0`

install_dir=${1:-"$HOME/bin"}

[ -d "$install_dir" ] || mkdir -p "$install_dir"

for name in *; do
  target="$install_dir/$name"

  if [[ ! `grep "^$name$" $PWD/do_not_install` ]]; then
    install $name $target
  fi
done
