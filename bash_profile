# only sources these if they exist
[[ -r ~/.git-completion.bash ]] && . ~/.git-completion.bash
[[ -r ~/.bash_aliases ]] && . ~/.bash_aliases
[[ -r ~/.bash_profile.local ]] && . ~/.bash_profile.local

export HISTTIMEFORMAT="%F %T "
export HISTSIZE=10000
export HISTCONTROL=ignorespace

export EDITOR="vim"
export VISUAL="vim"

# tmux/screen code needs to be loaded after
# everything else. it looks like starting
# one of the sessions interrupts normal
# sourcing of bash_profile

# start tmux or attach to an existing session
# only runs if tmux exists and we're not in
# an active tmux/screen session right now
SCREEN_STATUS=$(screen -q -ls; echo $?) # eq 8 when no screen is running
START_SCREEN=$(which true)
if which tmux >/dev/null 2>&1 && [[ -z $TMUX ]] && [[ $SCREEN_STATUS -eq 8 ]] 
then
  START_SCREEN=$(which false)
  tmux attach >/dev/null 2>&1 || tmux new-session -s main
fi

# open screen at start - use instead of tmux if you want
if $START_SCREEN && [[ -z $TMUX ]]
then
  if [[ $SCREEN_STATUS -le 9 ]] # no screens are running
  then
    screen -d -m -S main
    screen -S main -p 1 -X stuff "clear$(printf \\r)"
    screen -rd
  fi
fi

