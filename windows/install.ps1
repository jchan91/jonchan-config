param(
    $installConEmu,
    $installGit,
    $matlabScripts,
    $installVsCode,
    $installExtensions,
    $isTest = $true
)

#####################################
## Functions
#####################################
function Copy-SettingsFile(
    $src,
    $dst
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
    $stdOutPath = ""
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

    return $response -eq "y"
}


# Prompts the host with a question. Returns their string answer.
function AskHostString($question) {
    return Read-Host -Prompt "$question (leave empty to skip)"
}


#####################################
## Main Logic
#####################################
$username = $ENV:USERNAME
$appDataRoot = $ENV:APPDATA
$scriptRoot = $PSScriptRoot

# Prompt user for inputs
if (-Not $installConEmu) {
    $installConEmu = AskHostTrueFalse("Install ConEmu.xml?")
}
if (-Not $installGit) {
    $installGit = AskHostTrueFalse("Install git config?")
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

# ConEmu
if ($installConEmu) {
    Write-Host "Install ConEmu"

    $exampleConEmuPath = "$scriptRoot\config\ConEmu.xml.example"
    $dstConEmuPath = "$appDataRoot\ConEmu.xml"
    Copy-SettingsFile -src $exampleConEmuPath -dst $dstConEmuPath
}

# Razzle


# Git
if ($installGit) {
    Write-Host "Installing git config"

    if (-not $isTest) {
        $customGitConfigPath = "$appDataRoot\config\.gitconfig"

        $cmd = "git"
        $params = @(
            "config",
            "--global",
            "--add", "include.path", $customGitConfigPath
        )
        Invoke-Cmd -cmd $cmd -params $params
    }
}

# Matlab
if ($matlabScripts) {
    Write-Host "Setting up Matlab"

    $userProfilePath = Get-Item $ENV:USERPROFILE
    $matlabProfilePath = "$userProfilePath\Documents\MATLAB"
    if (-Not (Test-Path -Path $matlabProfilePath)) {
        mkdir -Force $matlabProfilePath
    }
    Copy-SettingsFile -src "$matlabScripts\startup.m" -dst "$matlabProfilePath\startup.m"
}

# VSCode
if ($installVsCode) {
    Write-Host "Setting up VSCode"

    $exampleVsCodeSettingsPath = "$scriptRoot\config\example.vscode.settings.json"
    $dstVsCodeSettingsPath = "$appDataRoot\Code\User\settings.json"
    Copy-SettingsFile -src $exampleVsCodeSettingsPath -dst $dstVsCodeSettingsPath
}

# Default file extensions
if ($installExtensions) {
    Write-Host "Setting up default programs for extensions"

    if (-not $isTest) {
        setExtensionDefaults.bat
    }
}