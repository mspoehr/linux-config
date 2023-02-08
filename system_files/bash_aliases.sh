# shellcheck disable=SC2148
# ~/.bash_aliases

if $MAC; then
  alias zcat='gzcat'
fi

alias ls='exa -F'
alias ll='exa --git -alFh'
alias l='exa -F'
alias cat='bat --plain'
alias g='git'

which fdfind &>/dev/null && alias fd='fdfind'