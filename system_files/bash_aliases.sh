# shellcheck disable=SC2148
# ~/.bash_aliases

if $MAC; then
  alias zcat='gzcat'
fi

if is_installed eza; then
  alias ls='eza -F'
  alias ll='eza --git -alhF'
  alias l='eza -F'
fi

if is_installed bat; then
  alias cat='bat --plain'
fi

if is_installed batcat; then 
  alias cat="batcat --plain"
fi

if is_installed xclip; then
  alias pbcopy="xclip -selection clipboard"
  alias pbpaste="xclip -selection clipboard -o"
fi

alias t="terraform"
alias g='git'
alias gpushnow="git commit --amend --no-edit -a && git push --force-with-lease"
alias awsp='awsprofile $(pick_aws_config)'

is_installed fdfind && alias fd='fdfind'
