#!/usr/bin/env bash

cd "$(dirname "$0")" || exit

# shellcheck disable=SC1091
source helper_scripts/local-helpers.sh

# Plain files
FILES_DIR=system_files

install -m 644 $FILES_DIR/bashrc.sh ~/.bashrc
install -m 644 $FILES_DIR/bash_profile.sh ~/.bash_profile
install -m 644 $FILES_DIR/bash_aliases.sh ~/.bash_aliases
install -m 644 $FILES_DIR/bash_functions.sh ~/.bash_functions
install -m 644 $FILES_DIR/bash_prompt.sh ~/.bash_prompt
! $MAC || install -m 644 $FILES_DIR/brew_profile.sh ~/.brew_profile
mkdir -p ~/.config
install -m 644 $FILES_DIR/starship.toml ~/.config/starship.toml
! $MAC || touch ~/.hushlogin
install -m 644 $FILES_DIR/dircolors.sh ~/.dircolors
install -m 644 $FILES_DIR/vimrc ~/.vimrc
install -m 644 $FILES_DIR/badwolf.vim ~/.vim/colors/badwolf.vim
install -m 644 $FILES_DIR/gitconfig ~/.gitconfig
install -m 644 $FILES_DIR/gitignore_global ~/.gitignore_global
install -m 644 $FILES_DIR/ripgreprc ~/.ripgreprc
install -m 644 $FILES_DIR/com.googlecode.iterm2.plist ~/.config/com.googlecode.iterm2.plist

