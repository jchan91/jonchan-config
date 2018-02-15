# Custom settings
#
if [ -f "${HOME}/.bash_custom" ]; then
    source "${HOME}/.bash_custom"
fi				   

# Aliases
#
# Some people use a different file for aliases
if [ -f "${HOME}/.bash_aliases" ]; then
  source "${HOME}/.bash_aliases"
fi

alias emacs="/usr/local/Cellar/emacs/25.3/Emacs.app/Contents/MacOS/Emacs -nw"