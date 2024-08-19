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
        eza \
        fzf

    if $MAC; then
        brew install \
            coreutils \
            gnu-sed \
            gnu-tar \
            gnupg \
            grep

        brew install --cask font-fira-code-nerd-font

        curl -L https://iterm2.com/shell_integration/bash -o ~/.iterm2_shell_integration.bash
        # exec bash # this used to work, but now it doesn't...
        echo $(brew --prefix)/bin/bash | sudo tee -a /private/etc/shells
        sudo chpass -s $(brew --prefix)/bin/bash $(whoami)
    fi
fi

if has_arg "macos-gui"; then
    brew tap homebrew/cask-drivers
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
        shellcheck \
        jq

    if $MAC; then
        brew install --cask \
            visual-studio-code
    fi
fi

if has_arg "webdev"; then
    brew install --cask \
        firefox \
        google-chrome \
        postman \
        sf-symbols

    # TODO: is there a way to install colorslurp via brew?
fi

if has_arg "rvm"; then
    gpg --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable
    source /Users/michaelspoehr/.rvm/scripts/rvm
fi

if has_arg "awscli"; then
    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
    sudo installer -pkg ./AWSCLIV2.pkg -target /
    which aws
    aws --version
fi

if has_arg "java-dev"; then
    brew install openjdk@17
    sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk

    brew install gradle
fi

if has_arg "ebcli"; then
  if [[ ! $(which python3) ]]; then
    brew install python3
  fi

  pip3 install --user virtualenv
  git clone https://github.com/aws/aws-elastic-beanstalk-cli-setup.git
  python3 ./aws-elastic-beanstalk-cli-setup/scripts/ebcli_installer.py
  rm -rf aws-elastic-beanstalk-cli-setup
fi
