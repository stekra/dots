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
PS1="\[\e[7m\]\u@\h\[\e[0m\] \w $ "

# environment
VISUAL=nvim

# path
export PATH=$PATH:$HOME/.config/scripts

# aliases
alias vim='nvim'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias yeet='rm -rf'

# dotfiles
# set up on new machine:
    # echo ".dots" >> .gitignore
    # git clone --bare git@github.com:stekra/dots.git $HOME/.dots
    # dots checkout
    # dots config --local status.showUntrackedFiles no
alias dots='git --git-dir=$HOME/.dots/ --work-tree=$HOME'

