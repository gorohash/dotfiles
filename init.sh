#!/usr/bin/env bash

basedir=$(cd $(dirname $0); pwd)

ln -sf ${basedir}/.tigrc ~/.tigrc
ln -sf ${basedir}/.vimrc ~/.vimrc
ln -sf ${basedir}/.zshrc ~/.zshrc
ln -sf ${basedir}/.vim ~/.vim
