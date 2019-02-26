param(
    $matlabScripts,
    $isTest = $true
)

function Copy-SettingsFile(
    $src,
    $dst,
    $isTest
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

$username = $ENV:USERNAME
$appDataRoot = $ENV:APPDATA

if (-Not $matlabScripts) {
    $matlabScripts = Read-Host -Prompt "Enter MATLAB Scripts Root"
}

if ($matlabScripts) {
    Write-Host "Setting up Matlab"

    $userProfilePath = Get-Item $ENV:USERPROFILE
    $matlabProfilePath = "$userProfilePath\Documents\MATLAB"
    if (-Not (Test-Path -Path $matlabProfilePath)) {
        mkdir -Force $matlabProfilePath
    }
    Write-Host "$matlabProfilePath\startup.m"
    Copy-SettingsFile -src "$matlabScripts\startup.m" -dst "$matlabProfilePath\startup.m" -isTest $isTest
}

# VSCode
$exampleVsCodeSettingsPath = "$PSScriptRoot\example.vscode.settings.json"
$dstVsCodeSettingsPath = "$appDataRoot\Code\User\settings.json"
Copy-SettingsFile -src $exampleVsCodeSettingsPath -dst $dstVsCodeSettingsPath -isTest $isTest
Copy-Item -Path $exampleVsCodeSettingsPath -Destination $dstVsCodeSettingsPath
