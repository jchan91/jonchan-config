param(
    $use_vs_build=$false
)

Write-Host "Loading profile.ps1"

# Use oh-my-posh
Import-Module posh-git
Import-Module oh-my-posh
Set-Prompt
Set-Theme Honukai
$ThemeSettings.Colors.PromptHighlightColor = [ConsoleColor]::Cyan

# Note that this script is in the config dir
$config_root = "$env:APPDATA\profile_config" # TODO: Make this more generic
$script_dir = "$config_root\windows"

Import-Module "$script_dir\common.psm1" -Force


# Set command prompt coloring
# set PROMPT=$_$E[31m$T$_$E[0:37m$+$E[1;33m$M$E[0:37m$E[1;33m$P$E[0:37m$_$E[0:37m$G$S$E[0m
# color 0b

# Setting PATH

# Misc
$env:PATH += "C:\Program Files\doxygen\bin;"
$env:PATH += "C:\Program Files (x86)\Graphviz2.38\bin;"
$env:PATH += "C:\Program Files\KDiff3;"
$env:PATH += "C:\Program Files\GTK2-Runtime Win64\bin;"
$env:PATH += "C:\ProgramData\tools\nuget;"
$env:PATH += "C:\ProgramData\tools\Strings;"
$env:PATH += "$script_dir;"

# General packaging
$env:PATH += "C:\ProgramData\chocolatey\bin;"
$env:PATH += "C:\Users\$env:USERNAME\pkgs\bin;"

# Git
$env:PATH += "C:\Program Files\Git\bin;"
$env:PATH += "C:\Program Files\Git\usr\bin;"
$env:PATH += "C:\Program Files (x86)\Meld;"

# Editors
# $env:PATH += "C:\Program Files\Microsoft VS Code\;"
$env:PATH += "C:\Program Files\Sublime Text 3\;"
$env:PATH += "C:\Users\jonch\AppData\Local\Programs\Microsoft VS Code\;"

# Python stuff
$conda_path = "C:\ProgramData\Anaconda3\Scripts"
$env:PATH += $conda_path

# Azure
$env:PATH += "C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy;"

# Android
Set-Variable "ANDROID_HOME" "$env:LOCALAPPDATA\Android\Sdk"

# Java
Set-Variable "JAVA_HOME" "C:\Program Files\Java\jdk1.8.0_201"

# CMake
$env:PATH += "C:\Program Files\CMake\bin;"

# smerge
$env:PATH += "C:\Program Files\Sublime Merge;"

# Useful utility commands
function TitleAlias($name) { $host.ui.RawUI.WindowTitle = $name }
Set-Alias -Name title -Value TitleAlias

function SublimeAlias() { Invoke-Exe -exePath sublime_text.exe -params @("-n", $args) -StartDaemon }
Set-Alias -Name sublime -Value SublimeAlias

function EditProfileAlias() { code -n $config_root }
Set-Alias -Name editprofile -Value EditProfileAlias

# function SourceProfileAlias() { & "$script_root\profile.ps1" }
# Set-Alias -Name sourceprofile -Value SourceProfileAlias

function UpdateProfileAlias() {
    Copy-Item "$script_dir\profile.ps1" $profile -Force
    Copy-Item "$script_dir\profile.ps1" "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.VSCode_profile.ps1" -Force
}
Set-Alias -Name updateprofile -Value UpdateProfileAlias

function CdProfileAlias() { Set-Location $config_root}
Set-Alias -Name cdprofile -Value CdProfileAlias

function ClippAlias() { Set-Clipboard $pwd.Path }
Set-Alias -Name clipp -Value ClippAlias

# function LessAlias() { less.exe -i $args }
# Set-Alias -Name less -Value LessAlias

# function FzfAlias { fzf.exe --print0 $args | clip }
# Set-Alias -Name fzf -Value FzfAlias

# function TreeAlias() { tree.exe /A $args | less.exe -i }
# Set-Alias -Name tree -Value TreeAlias

function AdbAlias() { & "$env:ANDROID_HOME\platform-tools\adb.exe" $args }
Set-Alias -Name adb -Value AdbAlias

if ($use_vs_build) {
    # Setup VS env variables. ***Must be called last***

    # Try VS Community
    $msbuild_bat_path = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\VsMSBuildCmd.bat"
    if (Test-Path $msbuild_bat_path) {
        Write-Host "Loading VS Community Build bat"
        & $msbuild_bat_path
    }

    # Try VS Enterprise
    $msbuild_bat_path = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\Tools\VsMSBuildCmd.bat"
    if (Test-Path $msbuild_bat_path) {
        Write-Host "Loading VS Enterprise Build bat"
        & $msbuild_bat_path
    }
}