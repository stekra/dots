# ~/.bashrc: executed by bash(1) for non-login shells.

# if not running interactively, don't do anything
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

# completion
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'

# prompt
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
# PS1="\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
# PS1="\[\e[30;47m\]\u@\h\[\e[m\] \w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
# PS1="\[\e[7m\]\u@\h\[\e[0m\] \w $ "
PS1="\[\e[7m\]\w\[\e[0m\] $ "

# environment
VISUAL=nvim

# path
export PATH=$PATH:$HOME/.config/scripts

# aliases
alias dots='git --git-dir=$HOME/.dots/ --work-tree=$HOME'
alias vim='nvim'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias yeet='rm -rf'

