param(
    $installConEmu,
    $installGit,
    $installPsSetup,
    $matlabScripts,
    $installVsCode,
    $installExtensions
)

$ErrorActionPreference = "Stop"

Import-Module (Join-Path $PSScriptRoot '..' 'lib' 'common.psm1') -Force

#####################################
## Functions
#####################################
function Copy-SettingsFile(
    $src,
    $dst,
    $isTest=$false
) {
    if ($isTest) {
        if (-Not (Test-Path -Path $src)) {
            Write-Host "$src does not exist"
            return
        }
        if (Test-Path -Path $dst) {
            # Check if contents are the same
            $srcContent = [System.IO.File]::ReadAllText($src)
            $dstContent = [System.IO.File]::ReadAllText($dst)
            if ($srcContent -eq $dstContent) {
                Write-Host "No change between $dst and $src."
            }
            else {
                Write-Host "Would overwrite $dst with $src"
            }
            return
        }
        else {
            Write-Host "Would create new file at $dst with $src"
            return
        }
    }
    else {
        Write-Host "Copied $src to $dst"
        Copy-Item -Path $src -Destination $dst
    }
}


function Invoke-Cmd(
    $cmd,
    $params,
    $stdOutPath = "",
    $isTest=$false
) {
    if ($isTest) {
        Write-Host "Would run: $cmd $params"
        return
    }

    if ($stdOutPath) {
        & $cmd $params | Out-File -FilePath $stdOutPath -Encoding ASCII
    }
    else {
        & $cmd $params
    }
}


# Prompts the host with a true/false question. Returns their answer.
function InstallProfile() {
    $customProfilePath = Join-Path $PSScriptRoot "profile.ps1"

    # Default ps1 profile path
    AddProfile $profile $customProfilePath

    # VS Code profile path. Only install of we detect VSCode ps dir
    $vscodeProfileDir = "$env:USERPROFILE\Documents\PowerShell"
    if (Test-Path $vscodeProfileDir) {
        $vscodeProfilePath = "$vscodeProfileDir\Microsoft.VSCode_profile.ps1"

        AddProfile $vscodeProfilePath $customProfilePath
    }

    # Alternate VS Code profile path. Only install of we detect VSCode ps dir
    $vscodeProfileDir = "$env:USERPROFILE\OneDrive - Microsoft\Documents\PowerShell"
    if (Test-Path $vscodeProfileDir) {
        $vscodeProfilePath = "$vscodeProfileDir\Microsoft.VSCode_profile.ps1"

        AddProfile $vscodeProfilePath  $customProfilePath
    }
}


#####################################
## Main Logic
#####################################

# Run as admin
Invoke-ScriptAsAdmin $PSCommandPath

$username = $ENV:USERNAME
$appDataRoot = $ENV:APPDATA

# Prompt user for inputs
if (-Not $installConEmu) {
    $installConEmu = AskHostTrueFalse("Install ConEmu.xml?")
}
if (-Not $installGit) {
    $installGit = AskHostTrueFalse("Install git config?")
}
if (-Not $installPsSetup) {
    $installPsSetup = AskHostTrueFalse("Install Powershell setup?")
}
if (-Not $matlabScripts) {
    $matlabScripts = AskHostString("Enter MATLAB Scripts Root")
}
if (-Not $installVsCode) {
    $installVsCode = AskHostTrueFalse("Install VSCode config?")
}
if (-Not $installExtensions) {
    $installExtensions = AskHostTrueFalse("Set default programs for certain extensions?")
}

# Ask if user wants to commit
Write-Host ""
Write-Host ""
$readyToCommit = AskHostTrueFalse("Are you sure you want to make the above changes?")
if (-not $readyToCommit) {
    return
}
Write-Host ""
Write-Host ""

# ConEmu
if ($installConEmu -and $readyToCommit) {
    Write-Host "Install ConEmu"

    $exampleConEmuPath = "$scriptRoot\config\ConEmu.xml.example"
    $dstConEmuPath = "$appDataRoot\ConEmu.xml"
    Copy-SettingsFile -src $exampleConEmuPath -dst $dstConEmuPath
}

# Git
if ($installGit -and $readyToCommit) {
    Write-Host "Installing git config"

    $cmd = "git"

    # Unset any existing git config include.path
    $params = @(
        "config",
        "--global",
        "--unset-all", "include.path"
    )
    Invoke-Cmd -cmd $cmd -params $params

    # Set include.path
    $customGitConfigPath = Join-Path $scriptRoot 'config' '.gitconfig'
    $params = @(
        "config",
        "--global",
        "--add", "include.path", $customGitConfigPath
    )
    Invoke-Cmd -cmd $cmd -params $params

    $customGitConfigPath = Join-Path $scriptRoot '..' 'lib' '.gitconfig'
    $params = @(
        "config",
        "--global",
        "--add", "include.path", $customGitConfigPath
    )
    Invoke-Cmd -cmd $cmd -params $params
}

# Powershell
if ($installPsSetup -and $readyToCommit) {
    Write-Host "Installing Powershell profile setup"

    Install-Module posh-git -Scope CurrentUser
    Install-Module oh-my-posh -Scope CurrentUser
    InstallProfile
}

# Matlab
if ($matlabScripts -and $readyToCommit) {
    Write-Host "Setting up Matlab"

    $userProfilePath = Get-Item $ENV:USERPROFILE
    $matlabProfilePath = "$userProfilePath\Documents\MATLAB"
    if (-Not (Test-Path -Path $matlabProfilePath)) {
        mkdir -Force $matlabProfilePath
    }
    Copy-SettingsFile -src "$matlabScripts\startup.m" -dst "$matlabProfilePath\startup.m"
}

# VSCode
if ($installVsCode -and $readyToCommit) {
    Write-Host "Setting up VSCode"

    $exampleVsCodeSettingsPath = "$scriptRoot\config\example.vscode.settings.json"
    $dstVsCodeSettingsPath = "$appDataRoot\Code\User\settings.json"
    Copy-SettingsFile -src $exampleVsCodeSettingsPath -dst $dstVsCodeSettingsPath
}

# Default file extensions
if ($installExtensions -and $readyToCommit) {
    Write-Host "Setting up default programs for extensions"
    & "$scriptRoot\setExtensionDefaults.bat"
}

Write-Host "Installation Complete"
Start-Sleep -Seconds 3