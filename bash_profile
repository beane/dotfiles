# only sources these if they exist
[[ -r ~/.git-completion.bash ]] && . ~/.git-completion.bash
[[ -r ~/.bash_aliases ]] && . ~/.bash_aliases

# export PS1="beanemachine:\W > "

export HISTTIMEFORMAT="%F %T "
export HISTSIZE=10000
export HISTCONTROL=ignorespace

export EDITOR="vim"

# start tmux or attach to an existing session
# only runs if tmux exists and we're not in
# an active tmux session right now
if which tmux >/dev/null 2>&1 && [[ -z "$TMUX" ]]; then
  tmux attach || tmux new-session -n main
fi
