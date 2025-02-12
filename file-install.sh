#!/usr/bin/env bash

cd "$(dirname "$0")" || exit

# shellcheck disable=SC1091
source helper_scripts/local-helpers.sh

# Plain files
FILES_DIR=system_files
DIFF_MODE=false

while getopts 'd' OPTION; do
    case "$OPTION" in
        d)
            DIFF_MODE=true
            ;;
        ?)
            echo "script usage: $0 [-d]" >&2
            exit 1
            ;;
    esac
done

if $DIFF_MODE; then
    cmd="diff --unified=0"
else
    cmd="install -m 644"
fi

$cmd $FILES_DIR/bashrc.sh ~/.bashrc
$cmd $FILES_DIR/bash_profile.sh ~/.bash_profile
$cmd $FILES_DIR/bash_aliases.sh ~/.bash_aliases
$cmd $FILES_DIR/bash_functions.sh ~/.bash_functions
$cmd $FILES_DIR/bash_prompt.sh ~/.bash_prompt
$cmd $FILES_DIR/fzf.bash ~/.fzf.bash
! $MAC || $cmd $FILES_DIR/brew_profile.sh ~/.brew_profile
mkdir -p ~/.config
$cmd $FILES_DIR/starship.toml ~/.config/starship.toml
! $MAC || touch ~/.hushlogin
$cmd $FILES_DIR/dircolors.sh ~/.dircolors
$cmd $FILES_DIR/vimrc ~/.vimrc
mkdir -p ~/.vim/colors
$cmd $FILES_DIR/badwolf.vim ~/.vim/colors/badwolf.vim
$cmd $FILES_DIR/gitconfig ~/.gitconfig
$cmd $FILES_DIR/gitignore_global ~/.gitignore_global
$cmd $FILES_DIR/ripgreprc ~/.ripgreprc

if $MAC; then
    $cmd $FILES_DIR/amethyst.yml ~/.amethyst.yml
    
    mkdir -p ~/Library/KeyBindings
    $cmd $FILES_DIR/DefaultKeyBinding.dict ~/Library/KeyBindings/DefaultKeyBinding.dict
    for file in $FILES_DIR/preferences/*; do
        $cmd "$file" ~/Library/Preferences/$(basename "$file")
    done
fi

# Configure git email, as this may vary per system:
if [ -s ~/.gitemail ]; then
    gitemail=$(cat ~/.gitemail)
else
    echo -n "Enter the default email for git commits on this system: "
    read gitemail
    echo "$gitemail" > ~/.gitemail
fi

git config --global user.email "$gitemail"
