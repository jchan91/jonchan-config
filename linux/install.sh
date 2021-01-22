#!/bin/bash
set -e

askUserQuestion() {
    local question=$1

    local nl=$'\n'
    read -p "$question$nl"

    echo $REPLY
}

askUserYesNoQuestion() {
    local response=false

    local question=$1
    local reply=$(askUserQuestion "$question (y/n)")

    if [[ $reply =~ ^[Yy]$ ]]; then
        local response=true
    fi

    echo $response
}

what_to_install="$1"
determineWhetherToInstall() {
    local should_install=false

    local question=$1

    if [[ what_to_install == "all" ]]; then
        should_install=true
    else
        should_install=$(askUserYesNoQuestion "$question")
    fi

    echo $should_install
}

# Get this script's directory
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Create a temp dir for this script
temp_dir="$HOME/temp"
if ! [[ -e "$temp_dir" ]]; then
    mkdir "$temp_dir"
fi

# Update apt
sudo apt-get update

# Install git commands
# Overwrite existing user's .gitconfig
src_gitconfig_path="$script_dir/config/.gitconfig.for_user_profile"
dst_gitconfig_path="$HOME/.gitconfig"
if ! [[ -e "$dst_gitconfig_path" ]]; then
    cp "$src_gitconfig_path" "$dst_gitconfig_path"
fi

# Install light-weight essentials
sudo apt-get install -y zsh
sudo apt-get install -y vim
sudo apt-get install -y curl
sudo apt-get install -y silversearcher-ag
sudo snap install tree
sudo apt install xsel xclip

# Install oh-my-zsh
# Only install if it's not already there
zsh_profile_path="$HOME/.zshrc"
if ! [[ -e "$zsh_profile_path" ]]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# TODO: Modify .zshrc theme to jtriley for WSL

# Install awesome vim config
# Only install if it's not already there
amix_vimrc_path="$HOME/.vim_runtime"
if ! [[ -e "$amix_vimrc_path" ]]; then
    git clone --depth=1 https://github.com/amix/vimrc.git "$amix_vimrc_path"
    sh ~/.vim_runtime/install_awesome_vimrc.sh
fi

# Install fzf
fzf_path="$HOME/.fzf"
if ! [[ -e "$fzf_path" ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$fzf_path"
    yes | "$HOME/.fzf/install"
fi

# Install Linuxbrew
install_linuxbrew=$(determineWhetherToInstall "Install LinuxBrew?")
if [[ $install_linuxbrew == true ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

    # Add Linuxbrew to .profile. Need to add following string to profile.
    # e.g.
    #
    # eval $(/home/jonchan/.linuxbrew/bin/brew shellenv)
    #

    # Ask user where they installed linuxbrew
    linuxbrew_dir=$(askUserQuestion "Enter the path to .linuxbrew below (e.g. /home/jonchan):")

    # Create the string we need to add to the profile
    linuxbrew_path_cmd='eval $('
    linuxbrew_path_cmd+="$linuxbrew_dir/.linuxbrew/bin/brew shellenv"
    linuxbrew_path_cmd+=')'
    echo "$linuxbrew_path_cmd" >> ~/.profile
    echo "$linuxbrew_path_cmd" >> ~/.zprofile

    # Execute command in local shell so brew is immediately available
    $linuxbrew_path_cmd
fi

# Install C++
install_cpp=$(determineWhetherToInstall "Install C++?")
if [[ install_cpp == true ]]; then
    sudo apt-get install -y g++ cmake clang lld ninja-build gdb
fi

# Install git-credential-manager
install_git_cred_manager=$(determineWhetherToInstall "Install git-credential-manager?")
if [[ $install_git_cred_manager == true ]]; then
    brew update
    brew install git-credential-manager
    git-credential-manager install
    sudo git config --global credential.canFallBackToInsecureStore true
fi

# Install Powershell
install_powershell=$(determineWhetherToInstall "Install Powershell?")
if [[ $install_powershell == true ]]; then
    wget -O "$temp_dir/packages-microsoft-prod.deb" -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    sudo apt-get update
    sudo add-apt-repository universe
    sudo apt-get install -y powershell

    sudo apt-get install -y apt-transport-https
    sudo apt-get update
    sudo apt-get install -y dotnet-sdk-3.1
fi

# Install bonus packages
install_bonuses=$(determineWhetherToInstall "Install bonus packages?")
if [[ $install_bonuses == true ]]; then
    sudo apt-get install -y meld
fi

#####################################################
## TODO: Add aliases to .zshrc or alias file
#####################################################

#####################################################
## Stuff that requires manual intervention
#####################################################

# Install Anaconda
install_conda=$(determineWhetherToInstall "Install Anaconda for python?")
if [[ $install_conda == true ]]; then
    anaconda_installer_path="$temp_dir/Miniconda3-latest-Linux-x86_64.sh"
    if ! [[ -e "$anaconda_installer_path" ]]; then
        wget -O "$anaconda_installer_path" https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
        sh "$anaconda_installer_path"
    fi
fi
