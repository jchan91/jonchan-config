param(
    $matlabScripts
)

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
    Copy-Item "$matlabScripts\startup.m" -Destination "$matlabProfilePath\startup.m"

}