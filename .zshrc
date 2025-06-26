# homebrew and python
export PATH="$(brew --prefix)/opt/python/libexec/bin:$PATH"
export HOMEBREW_NO_ENV_HINTS=1

# case insensitive completion
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# prompt
PROMPT=$'%{\e[7m%}%n@%m%{\e[0m%} %~ $ '

# variables
export VISUAL=nvim

# aliases
alias dots='git --git-dir=$HOME/.dots/ --work-tree=$HOME'
alias vim='nvim'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias yeet='rm -rf'
