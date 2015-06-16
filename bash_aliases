#!/bin/sh
alias be="bundle exec"
alias ls="ls -FG --color=auto" # shows directories in a different color
alias grep='grep -n --color=auto'
alias tailf='tail -f'

# git functions thanks to my boss, Jay
# get branch fresh from remote
function gget() {
  git branch -D $1
  git fetch
  git checkout --track -b $1 origin/$1
}

# get merge
function gmf() {
  echo "merging "$1" into "$2
  echo "*****"
  echo gget $1
  gget $1
  echo "*****"
  echo gget $2
  gget $2
  echo "*****"
  echo git merge --no-ff $1
  git merge --no-ff $1
}

# recursively greps through the current directory
function search() {
  search_dir="$2"
  if [[ ! $2 ]];
  then
    search_dir="$(pwd)"
  fi

  echo "searching for \"$1\" in $search_dir"
  if [[ $3 ]]
  then
    echo "using extra args \"$3\""
  fi

  grep -Irn "$1" "$search_dir" $3
}

# escapes space characters in ls command for copy and paste
# I might add logic for keeping color output, but that's bad for file IO
# something like `env CLICOLOR_FORCE=1 /bin/ls $@ | sed -e 's/\ /\\ /g'`
function els() {
  /bin/ls $@ | sed -e "s:[ ()[\\!@$=^&*\`;:?\"'|,<>]:\\\&:g"
}

# opens a file in vim with name $1.timestamp
function vin() {
  vim $1.$(date -u +%Y%m%d%H%M%S)
}

# want to be able to switch between ~/.ssh.work and ~/.ssh.home
# if one exists, use it and change the current ~/.ssh to the other

# takes three arguments
# 1) the base filename
# 2) and 3) are the extensions
function swapFiles() {
  file1=$1.$2
  file2=$1.$3

  if [[ -e $file1 ]] && [[ -e $file2 ]];
  then
    echo "Dangerous to swap since both files exist"
    return 0
  fi

  if [[ ! -e $1 ]];
  then
    echo "Base file doesn't exist"
    return 0
  fi

  if [[ -e $file1 ]];
  then
    mv $1 $file2
    mv $file1 $1
    echo "Using $2 now"
  elif [[ -e $file2 ]];
  then
    mv $1 $file1
    mv $file2 $1
    echo "Using $3 now"
  else
    echo "These files aren't here"
  fi
}

function pp() {
  cat "$@" | $HOME/.json_pretty_printer.rb
}
