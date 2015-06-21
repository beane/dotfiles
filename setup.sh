#!/bin/bash
############################
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
# thanks to http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
############################

########## git prep

git submodule init
git submodule update

########## Variables

DOTFILES=~/dotfiles                    # dotfiles directory
OLDDOTFILES=~/dotfiles_old             # old dotfiles backup directory
FILES="bash_profile vimrc gitconfig bash_aliases git-completion.bash inputrc json-pretty-print/json_pretty_printer.rb tmux.conf" # list of files to copy

########## Showtime

# create dotfiles_old in homedir
echo "Creating $OLDDOTFILES for backup of any existing dotfiles in ~"
mkdir -p $OLDDOTFILES
echo "...done"
echo ""

# change to the dotfiles directory
echo "Changing to the $DOTFILES directory"
cd $DOTFILES
echo "...done"
echo ""

# move any existing dotfiles in homedir to dotfiles_old directory, then move new dotfiles in
for FILE in $FILES; do
    echo "Moving any existing dotfiles from ~ to $OLDDOTFILES."
    DIR=$(dirname $FILE)
    BASE=$(basename $FILE)
    mv ~/.$BASE $OLDDOTFILES/ || echo "~/.$BASE does not exist."
    echo "Copying $DIR/.$BASE to home directory."
    echo ""
    cp -r $DIR/$BASE ~/.$BASE # might need a different flag to copy directories
done

# move vagrant stuff over
echo "Moving vagrant files to ~"
cp -R $DOTFILES/vagrant ~
echo "...done"
echo ""

echo "Sourcing .bash_profile"
source ~/.bash_profile
echo "...done"
echo ""

