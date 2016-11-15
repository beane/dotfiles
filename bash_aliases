#!/bin/sh

#############################
#         ALIASES           #
#############################

alias be="bundle exec"
alias ls="ls -FG --color=auto" # shows different filetypes in different colors
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias zgrep='zgrep --color=auto'
alias tailf='tail -f'
alias du='du -c'
alias jcurl='curl -H "Content-Type: application/json"'
alias rvim="vim -R" # opens vim in read-only mode

#############################
#         FUNCTIONS         #
#############################

# echo with timestamps
function debug() {
    local debug_time
    debug_time="$(date)"
    echo "$debug_time $1"
}

alias wtf="debug"

# recursively greps through the current directory
function search() {
    local search_term search_dir
    search_term="$1"
    search_dir="$2"

    [[ -z "$search_dir" ]] && search_dir="$(pwd)"

    echo "searching for \"$search_term\" in $search_dir"
    [[ -n $3 ]] && echo "using extra args \"$3\""

    grep -IHrn "$search_term" "$search_dir" $3
}

function find_and_replace() {
    [[ -z "$DIR" ]] && DIR=$(pwd)
    [[ -z "$2" ]] && echo "no replacement string given: searching instead"

    echo "looking for \"$1\" in $DIR"
    for file in $(grep -Irl "$1" "$DIR")
    do
        printf "\tfound match in $file\n"
        [[ -n "$2" ]] && sed -i "" -e "s:$1:$2:g" "$file"
    done
}

# opens a file in vim with name $1.timestamp
function vits() {
    vim $1.$(date -u +%Y%m%d%H%M%S)
}

# want to be able to switch between ~/.ssh.work and ~/.ssh.home
# if one exists, use it and change the current ~/.ssh to the other

# takes three arguments
# 1) the base filename
# 2) and 3) are the extensions
function swapFiles() {
    local file1 file2
    file1=$1.$2
    file2=$1.$3

    if [[ -e $file1 ]] && [[ -e $file2 ]];
    then
        echo "Dangerous to swap since both files exist"
        exit 1
    fi

    if [[ ! -e $1 ]];
    then
        echo "Base file doesn't exist"
        exit 2
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
    cat "$@" | $HOME/.pretty_printer
}

# escapes space characters in ls command for copy and paste
# I might add logic for keeping color output, but that's bad for file IO
# something like `env CLICOLOR_FORCE=1 /bin/ls $@ | sed -e 's/\ /\\ /g'`
function els() {
    /bin/ls $@ | sed -e "s:[ ()[\\!@$=^&*\`;:?\"'|,<>]:\\\&:g"
}

# only use with a single file at a time
function _sanitize() {
    help_text() {
        echo "
            Use the sanitize function to change dangerous filenames
            to use safe characters.

            Default behavior is to copy the dangerous files over
            and replace dangerous characters in the copy with '_'.

            Pass the -d flag to destroy the dirty files.

            The -h flag will show this help text.

            As always, -v provides verbose output.
        "
    }

    # need to set locally when
    # using getopts in a function
    local OPTIND option

    local FUNCTION=cp
    local MODIFYING="copying"
    local VERBOSE=1 # defaults to false

    while getopts "dhv" option; do
        case $option in
            d)
                FUNCTION=mv
                MODIFYING="moving"
                ;;
            v)
                VERBOSE=0
                ;;
            *) # also catches the -h option
                help_text
                return 1
                ;;
        esac
    done
    shift $((OPTIND-1))

    if [[ -z $@ ]]
    then
        echo "no file provided"
        return 2
    fi

    # try to ignore when the file name is unchanged
    SAFE_NAME=$(echo $@ | sed -e "s:[ ()[\\!@$=^&*\`;:?\"'|,<>]:_:g")
    if [[ $SAFE_NAME = "$@" ]]
    then
        [[ $VERBOSE -ne 1 ]] && echo "\"$@\" does not need to be sanitized"
        return 3
    fi

    [[ $VERBOSE -ne 1 ]] && echo "$MODIFYING \"$@\" to \"$SAFE_NAME\""

    # finally execute the command
    $FUNCTION "$@" "$SAFE_NAME"
}

# need to teach other subshells to inherit this
# function so that `find` knows how to use it
export -f _sanitize

# renames files in the current directory
# with dangerous characters to safer names
function sanitize() {
    local OPTIND option

    while getopts ":h" option; do
        case $option in
            h) # just shows the help menu
                _sanitize -h
                return 0
                ;;
        esac
    done

    find * -maxdepth 0 -type f -exec bash -c "_sanitize $@ '{}'" \;
}

# shows everything except the last `n` lines
# only needed on OSX for some reason
# normally head -n -<num> does this
function skip_last() {
    tail -r | tail -n +$(( $1 + 1 )) | tail -r
}

function today() {
    while [[ $# > 1 ]]; do
        case "$1" in
            -d|--delimiter)
                delim="$2"
                shift
                ;;
            *)
                ;;
        esac
        shift
    done

    if [ -z "$delim" ]; then
        delim=''
    fi

    echo "$(date +"%Y")$delim$(date +"%m")$delim$(date +"%d")"
}

function make_date_path() {
    if [[ -z $1 ]]
    then
        DIR=$(pwd)
    else
        DIR=$1
    fi
    mkdir -p "$DIR/$(today -d /)/"
}

function add() {
    args="$@"
    # handle piped arguments
    if [[ -z "$args" ]]
    then
        read args
    fi

    bc_script="0"
    for num in $args
    do
        bc_script="$num+$bc_script"
    done
    echo "$bc_script" | bc
}

### COLORS
# give thanks to the blessed http://stackoverflow.com/a/5947802
echo_with_color() {
    local color color_code

    color=$(echo "$1" | tr '[:upper:]' '[:lower]')

    # return if color is empty
    [[ -z "$color" ]] && exit 1

    color_code=""
    case "$color" in
        black)          color_code="\033[0;30m" ;;
        blue)           color_code="\033[0;34m" ;;
        brown|orange)   color_code="\033[1;33m" ;;
        cyan)           color_code="\033[0;36m" ;;
        dgray)          color_code="\033[1;30m" ;;
        green)          color_code="\033[0;32m" ;;
        lblue)          color_code="\033[1;34m" ;;
        lcyan)          color_code="\033[1;36m" ;;
        lgray)          color_code="\033[0;37m" ;;
        lgreen)         color_code="\033[1;32m" ;;
        lpurple)        color_code="\033[1;35m" ;;
        lred)           color_code="\033[1;31m" ;;
        purple)         color_code="\033[0;35m" ;;
        red)            color_code="\033[0;31m" ;;
        white)          color_code="\033[1;37m" ;;
        yellow)         color_code="\033[1;33m" ;;
        *)              exit 2 ;;
    esac

    shift

    echo "$color_code$@\033[0m"
}

