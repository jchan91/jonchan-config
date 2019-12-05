#!/bin/bash

# Get this script's directory
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd  )"

# Install git commands
# Overwrite existing user's .gitconfig
cp "$script_dir/../config/.gitconfig.for_user_profile" ~/.gitconfig

# Instal zsh
sudo apt-get install -y zsh

# Install common packages
sudo apt-get install -y curl
sudo apt-get install -y fzf
sudo apt-get install -y ag
sudo apt-get install -y meld
sudo snap install tree

# Install oh-my-zsh
curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh

# TODO: Modify .zshrc theme to jtriley for WSL

# Install awesome vim config
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh