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
else
    sourceIfPresent /etc/profile.d/bash_completion.sh
    sourceIfPresent /usr/share/bash-completion/completions/git
    sourceIfPresent /usr/share/autojump/autojump.sh
fi

# Load starship after sourcing files above, otherwise there'll be issues with cmd_duration
sourceIfPresent ~/.bash_prompt

# Load bash_completion (installed via brew on macos), for git autocompletion
__git_complete g git

# Set environment variables
PATH=$PATH:~/bin
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(vim {})+abort'" # ctrl-o opens file in vim
export RIPGREP_CONFIG_PATH=~/.ripgreprc
export EDITOR=vim

# use bat to page man files, if it is installed:
which bat &>/dev/null && export MANPAGER="sh -c 'col -bx | bat -l man -p'" || true

# Ensure that the SSH agent is running
ssh-add -L &>/dev/null
if [ "$?" == 2 ]; then
    # Could not open a connection to your authentication agent.
    eval $(ssh-agent -s)
fi

# ensure that SSH key is added to the agent
ssh-add -L | grep -q "$(cat .ssh/id_rsa.pub)" || ssh-add ~/.ssh/id_rsa
