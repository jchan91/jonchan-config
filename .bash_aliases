# Common program shortcuts
alias emacs="emacs -nw "
alias chrome="google-chrome"

# Set common home locations
alias sandbox='cd /home/$USER/sandbox'
#alias whome="cd /cygdrive/c/Users/jonathan"

# Git stuff
alias gitlog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gitdiff="git difftool -y"

# Open window explorer via CmdPrompt style
alias explore="nautilus --browser"
#alias start="explorer"

# Grep
alias grep='grep --color'
alias igrep='grep -i --color'                     # show differences in colour

# Default to human readable figures
alias df='df -h'
alias du='du -h'

# Safer move/copy/rm
alias mv='mv -i'
alias cp='cp -i'
#alias rm='rm -i'

# Some shortcuts for different directory listings
# alias ls='ls -hF --color=tty'                 # classify files in colour
# alias dir='ls --color=auto --format=vertical'
# alias lal='ls -Al --color=auto'
# alias vdir='ls --color=auto --format=long'
# alias ll='ls -l'                              # long list
# alias la='ls -A'                              # all but . and ..

# CMake shortcuts
alias cmake_eclipse='cmake -G"Eclipse CDT4 - Unix Makefiles" -D CMAKE_BUILD_TYPE=Debug'

#
# Misc :)
# alias less='less -r'                          # raw control characters
# alias whence='type -a'                        # where, of a sort
# alias egrep='egrep --color=auto'              # show differences in colour
# alias fgrep='fgrep --color=auto'              # show differences in colour
#
