# shellcheck disable=SC2148,1090
# ~/.bash_profile

[ -f ~/.profile ] && source ~/.profile
[ -f ~/.bashrc ] && source ~/.bashrc

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  export PATH="$PATH:$HOME/.rvm/bin"
  # shellcheck disable=SC1091
  source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
fi
