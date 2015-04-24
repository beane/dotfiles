#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
# thanks to http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
############################

########## git prep

git submodule init
git submodule update

########## Variables

dotfiles=~/dotfiles                    # dotfiles directory
olddotfiles=~/dotfiles_old             # old dotfiles backup directory
files="bashrc vimrc gitconfig bash_aliases git-completion.bash inputrc json-pretty-print/json_pretty_printer.rb" # list of files to copy

########## Showtime

# create dotfiles_old in homedir
echo "Creating $olddotfiles for backup of any existing dotfiles in ~"
mkdir -p $olddotfiles
echo "...done"
echo ""

# change to the dotfiles directory
echo "Changing to the $dotfiles directory"
cd $dotfiles
echo "...done"
echo ""

# move any existing dotfiles in homedir to dotfiles_old directory, then move new dotfiles in
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddotfiles."
    dir=$(dirname $file)
    base=$(basename $file)
    mv ~/.$base $olddotfiles/ || echo "~/.$base does not exist."
    echo "Copying $dir/.$base to home directory."
    echo ""
    cp -r $dir/$base ~/.$base # might need a different flag to copy directories
done

# move vagrant stuff over
echo "Moving vagrant files to ~"
cp -R $dotfiles/vagrant ~
echo "...done"
echo ""

echo "Sourcing .bash_profile"
source ~/.bashrc
echo "...done"
echo ""

