# export PS1="\[\e[36m\]\w\[\e[m\] \[\e[31m\]\\$\[\e[m\] "

alias ls='ls -Gh'

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "


#alias cat='ccat'

alias yeet='rm -rf'

alias c='cd ~/Creative/Code'
alias u='cd ~/Creative/Unity'
alias q='cd ~/Creative/Web/quadrilateral && code . && http-server -o'
alias z='cd ~/Learn/ZHdK'

alias o='open .'

alias s='http-server -o'

alias pip='pip3'

bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"

export PATH="/usr/local/opt/python/libexec/bin:$PATH"

export LC_ALL=en_US.UTF-8

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

