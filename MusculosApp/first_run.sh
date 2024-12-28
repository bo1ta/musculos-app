#!/bin/sh

brew update

function install_current {
  echo "Trying to update $1"

  # avoids errors
  brew upgrade $1 || brew install $1 || true
  brew link $1
}

if [ -e "Mintfile" ]; then
install_current mint
mint bootstrap --link
fi
