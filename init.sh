#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export PATH=$HOME/bin:$PATH:node_modules/.bin:$DIR/bin

# inspired by https://stackoverflow.com/questions/16715103/bash-prompt-with-last-exit-code
PROMPT_COMMAND=__prompt_command # Func to gen PS1 before generating each cmd prompt

__prompt_command() {
    local EXIT="$?"             # This needs to be first
    PS1=""

    local ResetCol='\[\e[0m\]'

    local Red='\[\e[0;31m\]'
    local Green='\[\e[0;32m\]'
    local Yellow='\[\e[1;33m\]'
    local Blue='\[\e[1;34m\]'
    local Purple='\[\e[0;35m\]'

    if [ $EXIT != 0 ]; then
        ERROR="${Red}($EXIT)${ResetCol} "
    else
        ERROR=""
    fi

    PS1+="${Green}\u${ResetCol}@${Blue}\h ${Yellow}\w ${ERROR}${ResetCol}$ "
}

# https://www.cyberciti.biz/tips/bash-shell-parameter-substitution-2.html
OSX_JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
export JAVA_HOME=${JAVA_HOME:-$OSX_JAVA_HOME}

export dev=~/dev
export projects=$dev/projects

export CDPATH=${CDPATH}:${dev}:${projects}:~

# Aliases
alias ls='ls -hG'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias c='clear'
alias q='exit'
alias e='exit'
alias d='cd $HOME/Downloads'
alias dev='cd $HOME/dev'
alias u='cd ..'
alias ..='cd ..'
alias pa="ps aux"
alias du='du -kh'    # Makes a more readable output.
alias df='df -kh'
alias h='history'
alias mkdir='mkdir -p'
alias test-push='read -p "All changes locally committed? [Enter]..." && git pull --rebase && sbt clean test && git push'
alias http='python -mSimpleHTTPServer'
alias noproxy="source $DIR/bin/noproxy.sh"

# PSEUDO ALIASES FOR COMMONLY USED LONG COMMANDS
# from http://cfenollosa.com/misc/tricks.txt
function lt() { ls -ltrsa "$@" | tail; }
function psgrep() { ps axu | grep -v grep | grep "$@" -i --color=auto; }
function fname() { find . -iname "*$@*"; }
function fnamegrep() { find . -type f -name "$1" -exec grep -i $2 {} \; ; }
#  removes lines from $1 if they appear in $2
function remove_lines_from() { grep -F -x -v -f $2 $1; }
function mcd() { mkdir $1 && cd $1; }

# SBT
export SBT_OPTS="-Xmx2024M -XX:ReservedCodeCacheSize=128m"

function jkill(){
  local to_kill=$1
  local pids=`jps | grep -i $to_kill | awk '{ print $1 }'`
  if [[ -n "$pids" ]]
  then
    kill -9 $pids
    echo "Killed Java processes for" \"$to_kill\" "with pid(s):" $pids
  else
    echo "Nothing to kill"
  fi
}

# automatically fixes your 'cd folder' spelling mistakes
shopt -s cdspell

. "$DIR"/gitconfig.sh


# requires > brew install bash-completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# requires > brew install thefuck
eval $(thefuck --alias)

echo "Environment setup... DONE. Hello `whoami`!"
