param(
    $use_vs_build=$false
)

# Note that this script is in the config dir
$script_dir = Resolve-Path $PSScriptRoot
$repo_root = Resolve-Path "$script_dir/.."
Import-Module "$repo_root/lib/common.psm1" -Force


### Functions
function TryLoadMsBuild(
    $architecture = "x64"
) {
    # Find the MSBuild Developer Prompt .bat script. Search in following order:
    $locationsForMsBuildToSearch = @(
        "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvarsall.bat",
        "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat"
    )

    $msbuild_bat_path = $null
    foreach ($path in $locationsForMsBuildToSearch) {
        if (Test-Path $path) {
            $msbuild_bat_path = $path
            break
        }
    }
    if ($null -eq $msbuild_bat_path) {
        Write-Error "Failed to find MSBuild path"
        return
    }

    # Can't just run the .bat file because it will set ENV in a new process. Need to extract out the ENV vars
    # into current powershell process.
    # https://stackoverflow.com/questions/2124753/how-can-i-use-powershell-with-the-visual-studio-command-prompt
    # https://docs.microsoft.com/en-us/cpp/build/building-on-the-command-line?view=msvc-160
    cmd /c "`"$msbuild_bat_path`" $architecture & set" |
        foreach {
            if ($_ -match "=") {
                $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
            }
        }
    Write-Host "`nVisual Studio Command Prompt variables set from $msbuild_bat_path targeting $architecture." -ForegroundColor Yellow
}


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

function EditProfileAlias() { code -n $repo_root }
Set-Alias -Name editprofile -Value EditProfileAlias

# function SourceProfileAlias() { & "$script_root\profile.ps1" }
# Set-Alias -Name sourceprofile -Value SourceProfileAlias

function InstallProfileAlias($profilePath) { AddProfile($profilePath) }
Set-Alias -Name installprofile -Value InstallProfileAlias

function CdProfileAlias() { Set-Location $repo_root}
Set-Alias -Name cdprofile -Value CdProfileAlias

function ClippAlias() { Set-Clipboard $pwd.Path }
Set-Alias -Name clipp -Value ClippAlias

# function LessAlias() { less.exe -i $args }
# Set-Alias -Name less -Value LessAlias

function FzfAlias { fzf.exe --print0 $args | clip }
Set-Alias -Name fzf -Value FzfAlias

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

        robocopy /J /Z /E $srcFolder $dst $srcFileName
    }
    else {
        robocopy /J /Z /E $src $dst
    }
}
Set-Alias -Name rcopy -Value RCopyAlias

function DirsAlias([string] $path) {
    Get-ChildItem -Path $path | Sort-Object -Property LastWriteTime
}
Set-Alias -Name dirs -Value DirsAlias

function NpmAlias() {
    & "C:\Program Files\nodejs\npm.cmd" $args
}
Set-Alias -Name npm -Value NpmAlias

# Load custom modules
LoadCustomModules $script_dir

if ($use_vs_build) {
    # Setup VS env variables. ***Must be called last***
    TryLoadMsBuild
}
