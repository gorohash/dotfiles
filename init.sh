#!/bin/sh

BASEDIR=$(cd $(dirname $0); pwd)

pushd $BASEDIR
  ln -sf ./.tigrc ~/.tigrc
  ln -sf ./.vimrc ~/.vimrc
  ln -sf ./.zshrc ~/.zshrc
  ln -sf ./.vim ~/.vim
popd
