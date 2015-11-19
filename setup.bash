#!/bin/bash
############################
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
# thanks to http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
############################

########## variables

DOTFILES=~/dotfiles                    # dotfiles directory
OLDDOTFILES=~/old_dotfiles             # old dotfiles backup directory
FILES="bashrc profile bash_profile bash_profile.local vimrc gitconfig gitignore_global bash_aliases git-completion.bash inputrc json-pretty-print/json_pretty_printer.rb tmux.conf screenrc" # list of files to copy
DIRECTORIES="vagrant"
REMOTE_URL="https://github.com/beane/dotfiles"

########## helper functions

function print_tab() { printf "\t"; }

########## git prep

git clone $REMOTE_URL $DOTFILES

cd $DOTFILES

git submodule init
git submodule update --recursive
git submodule foreach git fetch origin master
git submodule foreach git checkout master
git submodule foreach git pull origin master

########## showtime

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
echo ""
for FILE in $FILES; do
    BASE=$(basename $FILE)
    print_tab && echo "Backing up ~/.$BASE"
    print_tab && mv ~/.$BASE $OLDDOTFILES/ || print_tab && echo "~/.$BASE does not exist."
    print_tab && echo "Creating a symbolic link from $DOTFILES/$FILE to home directory."
    print_tab && ln -v -s $DOTFILES/$FILE ~/.$BASE
    echo ""
done
echo "...done"
echo ""

# move any existing dotfiles in homedir to dotfiles_old directory, then sym link new dotfiles in
echo "Begin backing up old directories and creating symbolic links to new dotfiles..."
echo ""
for DIR in $DIRECTORIES; do
    print_tab && echo "Backing up ~/.$BASE"
    print_tab && mv ~/$DIR $OLDDOTFILES/ || print_tab && echo "~/$DIR does not exist."
    print_tab && echo "Creating a symbolic link from $DOTFILES/$DIR to home directory."
    print_tab && ln -v -n -s $DOTFILES/$DIR ~/$DIR
    echo ""
done
echo "...done"
echo ""

echo "Sourcing .bash_profile"
source ~/.bash_profile
echo "...done"

echo "
Dotfiles are all installed!
You may want to log out and log back in for them to take effect.
(Or  source ~/.bash_profile.) Enjoy!
"
