#!/usr/bin/env bash

if ! $MAC; then
    echo "program-install.sh is not currently supported on Linux. Feel free to open a PR!"
    exit 1
fi

cd "$(dirname "$0")" || exit

# shellcheck disable=SC1091
source helper_scripts/local-helpers.sh

if ! $MAC; then
    UBU_REL=$(lsb_release -cs)
fi

# Update & exit
if has_arg "update"; then
    set -e
    sudo-pkg-mgr update && sudo-pkg-mgr upgrade -y
    sudo-pkg-mgr autoremove
    $WSL || sudo snap refresh
fi

if has_arg "shell"; then
    brew install \
        bash \
        bash-completion \
        vim \
        git \
        diff-so-fancy \
        autojump \
        bat \
        starship \
        ripgrep \
        fd \
        exa \
        fzf

    if $MAC; then
        brew install \
            coreutils \
            gnu-sed \
            gnu-tar \
            gnupg \
            grep 

        brew tap homebrew/cask-fonts
        brew install --cask font-fira-code-nerd-font

        curl -L https://iterm2.com/shell_integration/bash -o ~/.iterm2_shell_integration.bash
        exec bash
        echo $(brew --prefix)/bin/bash | sudo tee -a /private/etc/shells
        sudo chpass -s $(brew --prefix)/bin/bash $(whoami)
    fi
fi

if has_arg "macos-gui"; then
    brew install --cask \
        amethyst \
        brave-browser \
        iterm2 \
        itsycal \
        raycast \
        scroll-reverser \
        visual-studio-code
fi

if has_arg "dev"; then
    brew install \
        shellcheck

    if $MAC; then
        brew install --cask \
            postman \
            visual-studio-code
    fi
fi
