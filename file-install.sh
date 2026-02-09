#!/usr/bin/env bash

cd "$(dirname "$0")" || exit

# shellcheck disable=SC1091
source helper_scripts/local-helpers.sh

# Plain files
FILES_DIR=system_files
DIFF_MODE=false
SPECIFIC_FILES=()

while getopts 'd' OPTION; do
    case "$OPTION" in
        d)
            DIFF_MODE=true
            ;;
        ?)
            echo "script usage: $0 [-d] [file1 file2 ...]" >&2
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

# Collect specific files from remaining arguments
for arg in "$@"; do
    SPECIFIC_FILES+=("${arg#.}")
done

if $DIFF_MODE; then
    cmd="diff --unified=0"
else
    cmd="install -m 644"
fi

# File mapping: destination -> source
declare -A FILE_MAP=(
    [~/.bashrc]="$FILES_DIR/bashrc.sh"
    [~/.bash_profile]="$FILES_DIR/bash_profile.sh"
    [~/.bash_aliases]="$FILES_DIR/bash_aliases.sh"
    [~/.bash_functions]="$FILES_DIR/bash_functions.sh"
    [~/.bash_prompt]="$FILES_DIR/bash_prompt.sh"
    [~/.fzf.bash]="$FILES_DIR/fzf.bash"
    [~/.brew_profile]="$FILES_DIR/brew_profile.sh"
    [~/.config/starship.toml]="$FILES_DIR/starship.toml"
    [~/.dircolors]="$FILES_DIR/dircolors.sh"
    [~/.vimrc]="$FILES_DIR/vimrc"
    [~/.vim/colors/badwolf.vim]="$FILES_DIR/badwolf.vim"
    [~/.gitconfig]="$FILES_DIR/gitconfig"
    [~/.gitignore_global]="$FILES_DIR/gitignore_global"
    [~/.ripgreprc]="$FILES_DIR/ripgreprc"
    [~/.amethyst.yml]="$FILES_DIR/amethyst.yml"
    [~/Library/KeyBindings/DefaultKeyBinding.dict]="$FILES_DIR/DefaultKeyBinding.dict"
)

function should_install() {
    local dest="$1"
    
    # If no specific files requested, install all
    if [ ${#SPECIFIC_FILES[@]} -eq 0 ]; then
        return 0
    fi
    
    # Check if destination matches any requested file
    for file in "${SPECIFIC_FILES[@]}"; do
        if [[ "$dest" == *"$file" ]]; then
            return 0
        fi
    done
    return 1
}

function install_file() {
    local dest="$1"
    local src="$2"
    local mac_only="${3:-false}"
    
    if ! should_install "$dest"; then
        return
    fi
    
    if $mac_only && ! $MAC; then
        return
    fi
    
    mkdir -p "$(dirname "$dest")"
    $cmd "$src" "$dest"
}

# Install files
for dest in "${!FILE_MAP[@]}"; do
    src="${FILE_MAP[$dest]}"
    mac_only=false
    [[ "$dest" == *"brew_profile"* ]] || [[ "$dest" == *"amethyst"* ]] || [[ "$dest" == *"Library"* ]] && mac_only=true
    install_file "$dest" "$src" "$mac_only"
done

# Special case: .hushlogin
if $MAC && should_install "$HOME/.hushlogin" && [ ${#SPECIFIC_FILES[@]} -eq 0 ]; then
    touch ~/.hushlogin
fi

# Special case: preferences directory
if $MAC && ([ ${#SPECIFIC_FILES[@]} -eq 0 ] || should_install "preferences"); then
    for file in "$FILES_DIR"/preferences/*; do
        [ -f "$file" ] && install_file "$HOME/Library/Preferences/$(basename "$file")" "$file" true
    done
fi

# Configure git email only if installing gitconfig or no specific files
if should_install "$HOME/.gitconfig"; then
    if [ -s ~/.gitemail ]; then
        gitemail=$(cat ~/.gitemail)
    else
        echo -n "Enter the default email for git commits on this system: "
        read -r gitemail
        echo "$gitemail" > ~/.gitemail
    fi
    git config --global user.email "$gitemail"
fi
