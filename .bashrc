# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

alias config='/usr/bin/git --git-dir=/home/pi/.cfg/ --work-tree=/home/pi'

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
# export PS1="\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
export PS1="\[\e[30;47m\]\u@\h\[\e[m\] \w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

alias ls='ls --color=auto'
alias yeet='rm -rf'
alias pc='cd /home/pi/.lexaloffle/pico-8/carts'
