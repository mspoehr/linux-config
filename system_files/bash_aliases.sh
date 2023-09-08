# shellcheck disable=SC2148
# ~/.bash_aliases

if $MAC; then
  alias zcat='gzcat'
fi

alias ls='eza -F'
alias ll='eza --git -alFh'
alias l='eza -F'
alias cat='bat --plain'
alias g='git'

which fdfind &>/dev/null && alias fd='fdfind'
