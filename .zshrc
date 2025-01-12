export PATH="$(brew --prefix)/opt/python/libexec/bin:$PATH"
export PATH="/opt/homebrew/opt/tcl-tk/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/tcl-tk/lib"
export CPPFLAGS="-I/opt/homebrew/opt/tcl-tk/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/tcl-tk/lib/pkgconfig"
export HOMEBREW_NO_ENV_HINTS=1

# Case insensitive completion
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# eval "$(pyenv init -)"

alias dots='git --git-dir=$HOME/.dots/ --work-tree=$HOME'
PROMPT='%K{white}%F{black}%n@%m%k%f %~ $ '

