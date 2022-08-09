# Setup fzf
# ---------
if [[ ! "$PATH" == *$(brew --prefix)/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$(brew --prefix)/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$(brew --prefix)/opt/fzf/shell/completion.bash" 2> /dev/null
_fzf_setup_completion path nano
_fzf_setup_completion path vim
_fzf_setup_completion host dexssh

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Key bindings
# ------------
source "$(brew --prefix)/opt/fzf/shell/key-bindings.bash"
