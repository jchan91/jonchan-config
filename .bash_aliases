# Git stuff
alias gitlog="git log --pretty=format:\"%h %s\" --graph"
alias gitdiff="git difftool -y"

# Browser shortcut to chrome
alias chrome="google-chrome"

# Set windows home
#alias whome="cd /cygdrive/c/Users/jonathan"

# Open window explorer via CmdPrompt style
#alias start="explorer"
alias explore="nautilus --browser"

# Grep
alias grep='grep --color'
alias igrep='grep -i --color'                     # show differences in colour

#
# Default to human readable figures
# alias df='df -h'
# alias du='du -h'
#
# Misc :)
# alias less='less -r'                          # raw control characters
# alias whence='type -a'                        # where, of a sort
# alias egrep='egrep --color=auto'              # show differences in colour
# alias fgrep='fgrep --color=auto'              # show differences in colour
#

alias emacs="emacs -nw "
alias sandbox='cd /home/analog/sandbox'

# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty'                 # classify files in colour
alias dir='ls --color=auto --format=vertical'
alias lal='ls -Al --color=auto'

# alias vdir='ls --color=auto --format=long'
# alias ll='ls -l'                              # long list
# alias la='ls -A'                              # all but . and ..

# CMake shortcuts
alias cmake_eclipse='cmake -G"Eclipse CDT4 - Unix Makefiles" -D CMAKE_BUILD_TYPE=Debug'