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
FILES="bash_profile vimrc gitconfig bash_aliases git-completion.bash inputrc json-pretty-print/json_pretty_printer.rb tmux.conf screenrc" # list of files to copy

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

# move any existing dotfiles in homedir to dotfiles_old directory, then sym link new dotfiles in
echo "Begin backing up old files and creating symbolic links to new dotfiles..."
for FILE in $FILES; do
    BASE=$(basename $FILE)
    mv ~/.$BASE $OLDDOTFILES/ || echo "~/.$BASE does not exist."
    echo "Creating a symbolic link from $DOTFILES/$FILE to home directory."
    printf "\t"
    ln -v -s $DOTFILES/$FILE ~/.$BASE
    echo ""
done
echo "...done"
echo ""

# sym link vagrant stuff over
echo "Creating a symbolic link for vagrant files to $DOTFILES"
mv ~/vagrant ~/dotfiles
ln -v -s $DOTFILES/vagrant ~
echo "...done"
echo ""

echo "Sourcing .bash_profile"
source ~/.bash_profile
echo "...done"
echo ""

