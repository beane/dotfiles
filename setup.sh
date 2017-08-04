#!/bin/bash

# set -e sometimes suppresses messages from other utilities,
# so if shit breaks remove that flag to debug
set -ue

git submodule init
git submodule update --recursive
git submodule foreach git checkout master
git submodule foreach git pull origin master

cd home/
stow -t "$HOME" *

exit $?
