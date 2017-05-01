#!/bin/bash

# I should move this dir under the base.
# cd `dirname $0`

base="${HOME}/.homesick/repos"

if [[ ! -e "${base}" ]]; then
  echo "Cloning homeshick"
  git clone git://github.com/andsens/homeshick.git "${base}/homeshick"
fi

realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

dotfiles_repo="$(dirname $(realpath $0))"

if [[ ! -e "${base}/$(basename $dotfiles_repo)" ]]; then
  (cd $base && ln -s $dotfiles_repo)
fi
