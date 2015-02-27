#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
# thanks to http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="bashrc vimrc gitconfig bash_aliases git-completion.bash inputrc" # list of files to copy

##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"
echo ""

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"
echo ""

# move any existing dotfiles in homedir to dotfiles_old directory, then move new dotfiles in 
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir."
    mv ~/.$file $olddir/ || echo "~/.$file does not exist."
    echo "Copying .$file to home directory."
    echo ""
    cp -r $dir/$file ~/.$file # might need a different flag to copy directories
done

# move vagrant stuff over
echo "Moving vagrant files to ~"
cp -R $dir/vagrant ~
echo "...done"
echo ""

echo "Sourcing .bash_profile"
source ~/.bashrc
echo "...done"
echo ""


