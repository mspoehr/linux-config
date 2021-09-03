# shellcheck disable=SC2148
# ~/.bash_aliases


if $MAC; then
  alias zcat='gzcat'
fi

alias ls='ls -GFh'
alias ll='ls -al'
alias l='ls -CF'
alias cat='bat --plain'
alias g='git'
alias nano='vim'
alias t='rvm 2.7.3 do hours'
