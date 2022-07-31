# Prompt
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

#PS1="\[\e[36m\]\w\[\e[m\] \[\e[31m\]\\$\[\e[m\] "
#PS1="\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
#PS1="\u@\h \w\[\033[0;33m\]\$(parse_git_branch)\[\033[00m\] $ "
#PS1="\[\e[30;47m\]\u@\h\[\e[m\] \w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
#PS1='\[\e[0;7m\]\u\[\e[0;7m\]@\[\e[0;7m\]\h\[\e[0m\] \w \[\e[0m\]$ \[\e[0m\]'
# Path Only
PS1='\[\e[0m\]\w \[\e[0m\]$ \[\e[0m\]'

# Aliases
alias ls='ls -Gh'
alias yeet='rm -rf'
alias c='cd ~/Creative/Code'
alias u='cd ~/Creative/Unity'
alias q='cd ~/Creative/Web/quadrilateral'
alias qq='cd ~/Creative/Web/quadrilateral && code . && live-server'
alias z='cd ~/Learn/ZHdK'
alias pc='cd "/Users/sk/Library/Application Support/pico-8/carts"'
alias o='open .'
alias s='http-server -o'
alias pip='pip3'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias pico8='/Applications/pico-8/PICO-8.app/Contents/MacOS/pico8'

# Variables
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export EDITOR=nano
export VISUAL=nano

# Terminal
export LC_ALL=en_US.UTF-8
export BASH_SILENCE_DEPRECATION_WARNING=1
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
set +H # Disable history expansion
