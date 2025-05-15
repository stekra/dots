# homebrew and python
export PATH="$(brew --prefix)/opt/python/libexec/bin:$PATH"
export HOMEBREW_NO_ENV_HINTS=1

# case insensitive completion
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# prompt
PROMPT='%K{white}%F{black}%n@%m%k%f %1~ $ '

# variables
export EDITOR=nvim

# aliases
alias dots='git --git-dir=$HOME/.dots/ --work-tree=$HOME'
alias vim='nvim'

