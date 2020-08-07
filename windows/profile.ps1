param(
    $use_vs_build=$false
)


function SetupOhMyPosh($script_dir) {
    Import-Module posh-git
    Import-Module oh-my-posh
    Set-Prompt
    Set-Theme Honukai
    $ThemeSettings.Colors.PromptHighlightColor = [ConsoleColor]::Cyan
    
    # Load repository paths to ignore
    $poshGitIgnoreFilePath = "$script_dir\config\poshgit_ignore.txt"
    if (Test-Path $poshGitIgnoreFilePath) {
        foreach ($line in Get-Content $poshGitIgnoreFilePath) {
            $trimmedLine = $line.Trim()
            if ($trimmedLine.Length -eq 0) {
                continue
            }

            $GitPromptSettings.RepositoriesInWhichToDisableFileStatus += $trimmedLine
        }
    }
}


function AddToPathIfNotExists(
    [string[]] $pathsToAppend) {
    
    $currentPaths = $env:PATH -split ";"
    foreach ($path in $pathsToAppend) {
        # Only add a path if it doesn't already exist in current list of paths
        # Whole string match, case sensitive
        if ($currentPaths -contains $path) {
            continue
        }

        # Add the path
        $currentPaths += $path
    }

    # Set the PATH variable
    $env:PATH = $currentPaths -join ";"
}


function LoadCustomModules($scriptDir) {
    $modulesFilePath = "$scriptDir\config\custom_ps_modules.txt"
    if (Test-Path $modulesFilePath) {
        foreach ($line in Get-Content $modulesFilePath) {
            $trimmedLine = $line.Trim()
            if ($trimmedLine.Length -eq 0) {
                continue
            }

            if (-Not (Test-Path $trimmedLine)) {
                continue
            }

            Import-Module $trimmedLine
        }
    }
}


# Note that this script is in the config dir
$config_root = "$env:APPDATA\profile_config" # TODO: Make this more generic
$script_dir = "$config_root\windows"
Import-Module "$script_dir\common.psm1" -Force


### Main

# Use oh-my-posh
SetupOhMyPosh -script_dir $script_dir

# Setting PATH
$includePaths = New-Object Collections.Generic.List[string]

# Misc
$includePaths.Add("C:\Program Files\doxygen\bin")
$includePaths.Add("C:\Program Files (x86)\Graphviz2.38\bin")
$includePaths.Add("C:\Program Files\KDiff3")
$includePaths.Add("C:\Program Files\GTK2-Runtime Win64\bin")
$includePaths.Add("C:\ProgramData\tools\Strings")
$includePaths.Add($script_dir)

# General packaging
$includePaths.Add("C:\ProgramData\chocolatey\bin")
$includePaths.Add("C:\Users\$env:USERNAME\pkgs\bin")

# Git
$includePaths.Add("C:\Program Files\Git\bin")
$includePaths.Add("C:\Program Files\Git\usr\bin")
$includePaths.Add("C:\Program Files (x86)\Meld")

# Editors
# $includePaths.Add("C:\Program Files\Microsoft VS Code\")
$includePaths.Add("C:\Program Files\Sublime Text 3")
$includePaths.Add("C:\Users\jonch\AppData\Local\Programs\Microsoft VS Code")

# Python stuff
$includePaths.Add("C:\ProgramData\Anaconda3\Scripts")

# Azure
$includePaths.Add("C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy")

# CMake
$includePaths.Add("C:\Program Files\CMake\bin")

# smerge
$includePaths.Add("C:\Program Files\Sublime Merge")

# Set the path variable
AddToPathIfNotExists($includePaths)


### Other environment variables
# Android
$env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"

# Java
$env:JAVA_HOME = "C:\Program Files\Java\jdk1.8.0_201"


### Aliases
# Useful utility commands
function TitleAlias($name) { $host.ui.RawUI.WindowTitle = $name }
Set-Alias -Name title -Value TitleAlias

function SublimeAlias() { Invoke-ExeInternal -exePath sublime_text.exe -params @("-n", $args) -StartDaemon }
Set-Alias -Name sublime -Value SublimeAlias

function EditProfileAlias() { code -n $config_root }
Set-Alias -Name editprofile -Value EditProfileAlias

# function SourceProfileAlias() { & "$script_root\profile.ps1" }
# Set-Alias -Name sourceprofile -Value SourceProfileAlias

function InstallProfileAlias($profilePath) { AddProfile($profilePath) }
Set-Alias -Name installprofile -Value InstallProfileAlias

function CdProfileAlias() { Set-Location $config_root}
Set-Alias -Name cdprofile -Value CdProfileAlias

function ClippAlias() { Set-Clipboard $pwd.Path }
Set-Alias -Name clipp -Value ClippAlias

# function LessAlias() { less.exe -i $args }
# Set-Alias -Name less -Value LessAlias

# function FzfAlias { fzf.exe --print0 $args | clip }
# Set-Alias -Name fzf -Value FzfAlias

function TreeAlias() { tree.com /A $args | less.exe -i }
Set-Alias -Name tree -Value TreeAlias

function AdbAlias() { & "$env:ANDROID_HOME\platform-tools\adb.exe" $args }
Set-Alias -Name adb -Value AdbAlias

function RCopyAlias([string] $src, [string] $dst) {
    if (($src.Length -eq 0) -or ($dst.Length -eq 0)) {
        throw "Usage: rcopy <src> <dst>"
    }

    if (Test-Path $src -PathType leaf) {
        $srcFolder = [System.IO.Path]::GetDirectoryName($src)
        $srcFileName = [System.IO.Path]::GetFileName($src)

        robocopy /J /Z $srcFolder $dst $srcFileName
    }
    else {
        robocopy /J /Z $src $dst
    }
}
Set-Alias -Name rcopy -Value RCopyAlias

# Load custom modules
LoadCustomModules $script_dir

if ($use_vs_build) {
    # Setup VS env variables. ***Must be called last***
    TryLoadMsBuild
}
