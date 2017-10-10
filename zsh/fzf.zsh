# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="$PATH:/usr/local/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/usr/local/opt/fzf/shell/key-bindings.zsh"
if [[ -f "$(which rg)" ]]; then
    export FZF_DEFAULT_COMMAND="rg -g '' --files"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
