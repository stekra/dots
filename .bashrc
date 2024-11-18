#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

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

bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'

export EDITOR='nvim'
export VISUAL='nvim'

alias sudo='sudo -E -s '
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias dots='/usr/bin/git --git-dir="$HOME/.dots/" --work-tree="$HOME"'

#PS1='[\u@\h \W]\$ '

# parse_git_branch() {
#     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
# }
# export PS1="\[\e[30;47m\]\u@\h\[\e[m\] \w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

PS1="\[\e[30;107m\]\u@\h\[\e[0m\] \w $ "
