#!/usr/bin/env bash

# shellcheck disable=SC1091
source helper_scripts/local-helpers.sh

if $(which apt &>/dev/null) && has_arg "shell"; then
    sudo add-apt-repository -y ppa:aos1/diff-so-fancy
    sudo apt install -y curl gpg fd-find diff-so-fancy fzf ripgrep bat jq autojump
    curl -sS https://starship.rs/install.sh | sh

    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] https://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza

    if $WSL; then
        sudo apt install keychain
    fi

    exit 0
fi

if ! $MAC; then
    echo "program-install.sh is not currently supported on your OS/distribution. Feel free to open a PR!"
    exit 1
fi

cd "$(dirname "$0")" || exit

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
        fzf \
        jq

    if $MAC; then
        brew install \
            coreutils \
            gnu-sed \
            gnu-tar \
            gnupg \
            grep

        brew install --cask font-fira-code-nerd-font

        curl -L https://iterm2.com/shell_integration/bash -o ~/.iterm2_shell_integration.bash

        default_shell=$(brew --prefix)/bin/bash
        grep -q $default_shell /private/etc/shells || echo $default_shell | sudo tee -a /private/etc/shells
        sudo chpass -s $default_shell $(whoami)
    fi
fi

if has_arg "gui-common"; then
    brew tap homebrew/cask-drivers
    brew install --cask \
        amethyst \
        iterm2 \
        itsycal \
        raycast \
        scroll-reverser \
        visual-studio-code
fi

if has_arg "gui-work"; then
    brew install --cask \
        spotify \
        gimp
fi

if has_arg "gui-personal"; then
    brew install --cask \
        brave-browser \
        obsidian
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
