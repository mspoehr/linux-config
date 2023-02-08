# Setup fzf
# ---------
# if [[ ! "$PATH" == *$(brew --prefix)/opt/fzf/bin* ]]; then
#   export PATH="${PATH:+${PATH}:}$(brew --prefix)/opt/fzf/bin"
# fi

if $MAC; then
  fzf_scripts_location="$(brew --prefix)/opt/fzf/shell"
else
  fzf_scripts_location="/usr/share/doc/fzf/examples"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$fzf_scripts_location/completion.bash" 2> /dev/null
_fzf_setup_completion path nano
_fzf_setup_completion path vim
# Note: host completion option not supported in lower version of fzf in linux package managers

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Key bindings
# ------------
source "$fzf_scripts_location/key-bindings.bash"
