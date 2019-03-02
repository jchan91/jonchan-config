param(
    $installGit,
    $matlabScripts,
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


#####################################
## Main Logic
#####################################
$username = $ENV:USERNAME
$appDataRoot = $ENV:APPDATA

# Prompot user for inputs
if (-Not $installGit) {
    $installGit = Read-Host -Prompt "Install git config? (y/n)"
}
if (-Not $matlabScripts) {
    $matlabScripts = Read-Host -Prompt "Enter MATLAB Scripts Root (leave empty to skip)"
}

# Git
if ($installGit -and ($installGit.ToLower() -eq "y")) {
    $customGitConfigPath = "$appDataRoot\config\.gitconfig"

    $cmd = "git"
    $params = @(
        "config",
        "--global",
        "--add", "include.path", $customGitConfigPath
    )
    Invoke-Cmd -cmd $cmd -params $params
}

# Matlab
if ($matlabScripts) {
    Write-Host "Setting up Matlab"

    $userProfilePath = Get-Item $ENV:USERPROFILE
    $matlabProfilePath = "$userProfilePath\Documents\MATLAB"
    if (-Not (Test-Path -Path $matlabProfilePath)) {
        mkdir -Force $matlabProfilePath
    }
    Write-Host "$matlabProfilePath\startup.m"
    Copy-SettingsFile -src "$matlabScripts\startup.m" -dst "$matlabProfilePath\startup.m"
}

# VSCode
$exampleVsCodeSettingsPath = "$PSScriptRoot\example.vscode.settings.json"
$dstVsCodeSettingsPath = "$appDataRoot\Code\User\settings.json"
Copy-SettingsFile -src $exampleVsCodeSettingsPath -dst $dstVsCodeSettingsPath