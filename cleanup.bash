#!/bin/bash
############################
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
# thanks to http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
############################

########## helper functions

function print_tab() { printf "\t"; }

########## Variables

DOTFILES=~/dotfiles                    # dotfiles directory
OLDDOTFILES=~/old_dotfiles             # old dotfiles backup directory
FILES="bashrc profile bash_profile vimrc vimrc.bundles gitconfig gitignore_global bash_aliases git-completion.bash inputrc json-pretty-print/json_pretty_printer.rb tmux.conf screenrc" # list of files to copy
DIRECTORIES="vagrant"
VIM_DIRECTORIES="autoload colors plugged view"

########## Showtime
echo "Removing all provided symlinks"
for FILE in $FILES; do
    BASE=$(basename $FILE)
    # ~/.$BASE exists & is a symlink
    if [[ -L ~/.$BASE ]]; then
      print_tab && echo "Removing ~/.$BASE"
      print_tab && rm -f ~/.$BASE
      echo ""
    fi
done

for DIR in $DIRECTORIES; do
    # ~/$DIR exists & is a symlink
    if [[ -L ~/$DIR ]]; then
      print_tab && echo "Removing ~/$DIR"
      print_tab && rm -rf ~/$DIR
      echo ""
    fi
done

for DIR in $VIM_DIRECTORIES; do
    BASE=$(basename $DIR)
    if [[ -L ~/.vim/$BASE ]]; then
      print_tab && echo "Removing ~/.vim/$BASE"
      print_tab && rm -f ~/.vim/$BASE
      echo ""
    fi
done
echo "...done"
echo ""

if [[ -d "$OLDDOTFILES" ]]; then
  echo "Replacing dotfiles with those stored in $OLDDOTFILES"
  find "$OLDDOTFILES/" -mindepth 1 -maxdepth 1 -exec printf "\tCopying {} back to $HOME\n" \; -exec cp -R {} ~ \;
  echo "...done"
  echo ""
fi

# ~/.bash_profile exists & is executable
if [[ -x ~/.bash_profile ]]; then
  echo "Sourcing .bash_profile"
  source ~/.bash_profile
  echo "...done"
  echo ""
fi

echo "
Dotfiles are all uninstalled!
You may to log out and log back in for your old set to take effect.
(Or  source ~/.bash_profile.) We miss you already!
"
