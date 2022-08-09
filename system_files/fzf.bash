# Setup fzf
# ---------
# if [[ ! "$PATH" == *$(brew --prefix)/opt/fzf/bin* ]]; then
#   export PATH="${PATH:+${PATH}:}$(brew --prefix)/opt/fzf/bin"
# fi

if $MAC; then
  brew_install_loc="$(brew --prefix)/opt/fzf/shell"
else
  brew_install_loc="/usr/share/doc/fzf/examples"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$brew_install_loc/completion.bash" 2> /dev/null
_fzf_setup_completion path nano
_fzf_setup_completion path vim
# Note: host completion option not supported in lower version of fzf in linux package managers

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Key bindings
# ------------
source "$brew_install_loc/key-bindings.bash"
