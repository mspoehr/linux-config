# shellcheck disable=SC2148
# ~/.bash_aliases

if $MAC; then
  alias zcat='gzcat'
fi

alias ls='eza -F'
alias ll='eza --git -alhF'
alias l='eza -F'
alias cat='bat --plain'
alias t="terraform"
alias g='git'
alias gpushnow="git commit --amend --no-edit -a && git push --force-with-lease"
alias awsp='awsprofile $(pick_aws_config)'

which fdfind &>/dev/null && alias fd='fdfind'
