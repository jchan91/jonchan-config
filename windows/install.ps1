param(
    $installConEmu,
    $installGit,
    $installPsSetup,
    $matlabScripts,
    $installVsCode,
    $installExtensions
)

$scriptRoot = $PSScriptRoot
Import-Module "$scriptRoot\common.psm1" -Force

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
function AskHostTrueFalse($question) {
    $response = Read-Host -Prompt "$question (y/n)"
    $response = $response.ToLower()

    $responseIsTrue = $response -eq "y"

    if ($responseIsTrue) {
        Write-Host "User responded Yes"
    } 
    else {
        Write-Host "User responded No"
    }

    return $responseIsTrue
}


# Prompts the host with a question. Returns their string answer.
function AskHostString($question) {
    $response = Read-Host -Prompt "$question (leave empty or respond 'n' to skip)"

    if (-not $matlabScripts -or ($matlabScripts -eq "n")) {
        Write-Host "User responded with empty\n"
    }
    else
    {
        Write-Host "User responded with: $response\n"
    }
}

function InstallProfile() {
    Copy-Item "$scriptRoot\profile.ps1" $profile -Force
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
    $customGitConfigPath = "$scriptRoot\config\.gitconfig"

    $cmd = "git"

    # Unset any existing git config include.path
    $params = @(
        "config",
        "--global",
        "--unset-all", "include.path"
    )
    Invoke-Cmd -cmd $cmd -params $params

    # Set include.path
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