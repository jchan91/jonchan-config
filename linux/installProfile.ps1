$ErrorActionPreference = "Stop"

Import-Module (Join-Path $PSScriptRoot '..' 'lib' 'common.psm1') -Force

$customProfilePath = Join-Path $PSScriptRoot "profile.ps1"
AddProfile $profile $customProfilePath