function Invoke-ScriptAsAdmin(
    $scriptPath,
    $argumentList=@()) {

    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {

        if (-not $argumentList) {
            Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs
        }
        else {
            Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs -ArgumentList $argumentList
        }

        # Exit so that we don't re-run the script again after exiting this function
        exit
    }
    else {
        # Do nothing. Already admin.
    }
}

function Invoke-Exe(
    [string]$exePath,
    [string[]]$params,
    [string]$stdOutPath = "",
    [switch]$StartDaemon
) {
    $binPath = [System.IO.Path]::GetDirectoryName($exePath)
    $isPathSyntax = (-not [string]::IsNullOrWhiteSpace($binPath)) -and (Test-Path -Path $binPath -IsValid)

    # If caller gave a full path to exe, then verify exe exists.
    # Otherwise, just rely on process environment to resolve the exe
    if ($isPathSyntax -and (-not (Test-Path -Path $exePath))) {
        throw "'$exePath' does not exist"
    }

    Write-Host "$exePath $params"
    Push-Location $binPath
    if (-not $startDaemon) {
        if ($stdOutPath) {
            & $exePath $params *>&1 | Out-File -FilePath $stdOutPath -Encoding ASCII
        }
        else {
            & $exePath $params
        }

        if ($LASTEXITCODE -ne 0) {
            Pop-Location
            $last_exit_code = $LASTEXITCODE
            throw "$exePath $params exited with non-zero: $last_exit_code"
        }
    }
    else {
        if ($stdOutPath) {
            Start-Job -Init ([ScriptBlock]::Create("Set-Location '$pwd'")) -ScriptBlock { & $Using:exePath $Using:params *>&1 | Out-File -FilePath $Using:stdOutPath -Encoding ASCII }
        }
        else {
            Start-Job -Init ([ScriptBlock]::Create("Set-Location '$pwd'")) -ScriptBlock { & $Using:exePath $Using:params }
        }
    }
    Pop-Location
}

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

function AddProfile($profilePath) {
    $scriptRoot = $PSScriptRoot
    $customProfilePath = "$scriptRoot\profile.ps1"

    # Check if we should overwrite
    if (Test-Path $profilePath) {
        $overwrite = AskHostTrueFalse "Powershell profile '$profilePath' already exists. Remove existing profile?"
        if ($overwrite) {
            Write-Host "Removed existing profile"
            Remove-Item $profilePath
        }
    }

    Write-Host "Adding to custom profile to '$profilePath'"
    Add-Content $profilePath ('. "' + $customProfilePath + '"')
}