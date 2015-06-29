# only sources these if they exist
[[ -r ~/.git-completion.bash ]] && . ~/.git-completion.bash
[[ -r ~/.bash_aliases ]] && . ~/.bash_aliases
[[ -r ~/.bash_profile.local ]] && . ~/.bash_profile.local

export HISTTIMEFORMAT="%F %T "
export HISTSIZE=10000
export HISTCONTROL=ignorespace

export EDITOR="vim"
export VISUAL="vim"

# start tmux or attach to an existing session
# only runs if tmux exists and we're not in
# an active tmux session right now
# if which tmux >/dev/null 2>&1 && [[ -z "$TMUX" ]]; then
#  tmux attach || tmux new-session -n main
# fi
# tmux ls

# open screen at start - use instead of tmux if you want
# if [[ $( screen -ls | grep "No Sockets") ]]
# then
#   screen -dm -S main
#   screen -S main -p 1 -X stuff "clear; screen -ls$(printf \\r)"
#   screen -rd
# fi
# screen -ls

