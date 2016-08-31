#!/bin/bash
############################
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
# thanks to http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
############################

########## variables

DOTFILES=~/dotfiles                    # dotfiles directory
OLDDOTFILES=~/old_dotfiles             # old dotfiles backup directory
FILES="bashrc profile bash_profile bash_profile.local vimrc vimrc.bundles gitconfig gitignore_global bash_aliases git-completion.bash inputrc json-pretty-print/json_pretty_printer.rb tmux.conf screenrc" # list of files to copy
DIRECTORIES="vagrant"
VIM_DIRECTORIES="autoload colors plugged view"
REMOTE_URL="https://github.com/beane/dotfiles"

########## helper functions

function print_tab() { printf "\t"; }

########## git prep

# if the directory is already there, should git fetch/pull master
git clone $REMOTE_URL $DOTFILES

cd $DOTFILES

git submodule init
git submodule update --recursive
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
    BASE=$(basename $DIR)
    print_tab && echo "Backing up ~/$BASE"
    print_tab && mv ~/$BASE $OLDDOTFILES/ || print_tab && echo "~/$BASE does not exist."
    print_tab && echo "Creating a symbolic link from $DOTFILES/$BASE to home directory."
    print_tab && ln -v -n -s $DOTFILES/$BASE ~/$BASE
    echo ""
done
echo "...done"
echo ""

# create ~/.vim and all the nested directories it likes
echo "Begin backing up old vim directories and setting up vim folders and symlinks..."
echo ""
print_tab && echo "Backing up ~/.vim"
print_tab && mv -v -f ~/.vim $OLDDOTFILES/.vim
for DIR in $VIM_DIRECTORIES; do
    BASE=$(basename $DIR)
    print_tab && echo "Creating ~/.vim/$BASE"
    print_tab && mkdir -v -p ~/.vim/$BASE
done
echo ""
print_tab && echo "Creating a symlink vim-lucius to ~/.vim/colors"
print_tab && ln -v -n -s $DOTFILES/vim-lucius/colors/lucius.vim ~/.vim/colors/lucius.vim
print_tab && echo "Creating a symlink from vim-plug to ~/.vim/autoload"
print_tab && ln -v -n -s $DOTFILES/vim-plug/plug.vim ~/.vim/autoload/plug.vim
echo ""
echo "...done"
echo ""

echo "Sourcing .bash_profile"
source ~/.bash_profile
echo ""
echo "...done"

echo "
Dotfiles are all installed!
 
You may want to log out and log back in for them to take effect.
(Or  source ~/.bash_profile.)

If you use vim, remember to :PlugInstall.

Enjoy!
"
