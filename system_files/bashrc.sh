# shellcheck disable=SC2148
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

################################################################################
#                                                               default Ubuntu #

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

################################################################################
#                                                                   customized #

WSL=$(if uname -a | grep -iq microsoft; then echo 'true'; else echo 'false'; fi)
export WSL
MAC=$(if uname -a | grep -iq darwin; then echo 'true'; else echo 'false'; fi)
export MAC

if $MAC && ! which brew &>/dev/null; then
    # Homebrew is not on the PATH, which means our scripts will fail.

    if [[ -f /opt/homebrew/bin/brew ]]; then
        # Homebrew is not on the path by default on Apple Silicon, but it appears
        # to be installed in /opt/homebrew. We can automatically fix this.
        eval $(/opt/homebrew/bin/brew shellenv)
    else
        # Likely an intel mac and homebrew isn't installed (defaults to /usr/local/bin)
        echo "User scripts cannot run because brew is not on the path. Is it installed?"
        exit 1
    fi
fi

# Source other files
function sourceIfPresent() {
    [ -f $1 ] && source $1
}

sourceIfPresent ~/.bash_aliases
sourceIfPresent ~/.bash_functions
sourceIfPresent ~/.bash_variables
sourceIfPresent ~/.fzf.bash

if $MAC; then
    sourceIfPresent ~/.brew_profile
    sourceIfPresent $(brew --prefix)/etc/bash_completion
    sourceIfPresent $(brew --prefix)/etc/profile.d/autojump.sh
    sourceIfPresent ~/.iterm2_shell_integration.bash
else
    sourceIfPresent /etc/profile.d/bash_completion.sh
    sourceIfPresent /usr/share/bash-completion/completions/git
    sourceIfPresent /usr/share/autojump/autojump.sh
fi

# Load starship after sourcing files above, otherwise there'll be issues with cmd_duration
sourceIfPresent ~/.bash_prompt

function ifInstalled() {
    which "$1" &>/dev/null
}

# Setup autocompletion
__git_complete g git
ifInstalled aws && complete -C '/usr/local/bin/aws_completer' aws
ifInstalled terraform && complete -C '/usr/local/bin/terraform' terraform

# Set environment variables
PATH=$PATH:~/bin
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(vim {})+abort'" # ctrl-o opens file in vim
export RIPGREP_CONFIG_PATH=~/.ripgreprc
export EDITOR=vim

# Make macOS stop complaining about bash
if $MAC; then
   export BASH_SILENCE_DEPRECATION_WARNING=1
fi

# use bat to page man files, if it is installed:
ifInstalled bat && export MANPAGER="sh -c 'col -bx | bat -l man -p'" || true

# Ensure that the SSH agent is running
ssh-add -L &>/dev/null
if [ "$?" == 2 ]; then
    # Could not open a connection to your authentication agent.
    eval $(ssh-agent -s)
fi

# ensure that SSH key is added to the agent
key_file=$(fd -t f "id_(rsa|ecdsa)$" ~/.ssh)
if [[ -n "$key_file" && -f $key_file.pub && -f $key_file ]]; then
    ssh-add -L | grep -q "$(cat $key_file.pub)" || ssh-add $key_file
fi
