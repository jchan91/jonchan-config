function EnsureDir(
        # Path of the directory
        [Parameter(Mandatory=$true)]
        [string]$dirPath,

        # Whether to ensure directory is empty. Will delete any existing contents.
        [switch] $Clean,

        # If -Clean is also passed in, prompts the user if they want to delete if path already exists.
        [switch] $Ask
    ) {
    # Check for valid arguments
    if ($Ask -and (-not $Clean)) {
        throw "Invalid usage of -AskUser. Must pass in -Clean with -AskUser."
    }

    # If path exists, clean it up
    if ($Clean -and (Test-Path $dirPath -ErrorAction Stop)) {
        if ($Ask) {
            $cleanPath = AskHostTrueFalse "$dirPath already exists. Overwrite?"
            if (-not $cleanPath) {
                throw "Can't ensure a clean directory. Path already exists and user does not want to overwrite."
            }
        }

        # Delete the existing directory
        Remove-Item -Path $dirPath -Recurse -Force -ErrorAction Stop
    }

    # If path doesn't exist, then mkdir
    if (-not (Test-Path $dirPath -ErrorAction Stop)) {
        mkdir $dirPath > $null  # Redirect stdout of mkdir to null
    }
}


function Invoke-ScriptAsAdmin(
    $scriptPath,
    $argumentList=@()) {

    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        $shell = DetectShell

        if (-not $argumentList) {
            Start-Process $shell "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs
        }
        else {
            Start-Process $shell "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs -ArgumentList $argumentList
        }

        # Exit so that we don't re-run the script again after exiting this function
        exit
    }
    else {
        # Do nothing. Already admin.
    }
}

function DetectShell() {
    if ($PSVersionTable.PSEdition -eq "Desktop") {
        return "powershell.exe"
    }
    elseif ($PSVersionTable.PSEdition -eq "Core") {
        return "pwsh"
    }
    else {
        throw "Unrecognized PSEdition: $PSVersionTable.PSEdition"
    }
}

function Invoke-ExeInternal(
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


# Adds the sourcing of customProfilePath in the $profile of the current shell.
function AddProfile($profilePath, $customProfilePath) {
    # Check if we should overwrite
    if (Test-Path $profilePath) {
        $overwrite = AskHostTrueFalse "Powershell profile '$profilePath' already exists. Remove existing profile?"
        if ($overwrite) {
            Write-Host "Removed existing profile"
            Remove-Item $profilePath
        }
    }

    if (-not (Test-Path $profilePath)) {
        $profileDir = Split-Path -Path $profilePath
        EnsureDir -dirPath $profileDir
        New-Item -Path $profilePath -ItemType "file"
    }

    Write-Host "Adding to custom profile to '$profilePath'"
    Add-Content $profilePath ('. "' + $customProfilePath + '"')
}


function TryLoadMsBuild() {
    # Try VS Community
    $msbuild_bat_path = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\VsMSBuildCmd.bat"
    if (Test-Path $msbuild_bat_path) {
        Write-Host "Loading VS Community Build bat"
        & $msbuild_bat_path
    }

    # Try VS Enterprise
    $msbuild_bat_path = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\Tools\VsMSBuildCmd.bat"
    if (Test-Path $msbuild_bat_path) {
        Write-Host "Loading VS Enterprise Build bat"
        & $msbuild_bat_path
    }
}


function SetupOhMyPosh($script_dir) {
    Import-Module posh-git
    Import-Module oh-my-posh
    Set-Prompt
    Set-Theme Honukai
    $ThemeSettings.Colors.PromptHighlightColor = [ConsoleColor]::Cyan

    # Load repository paths to ignore
    $poshGitIgnoreFilePath = "$script_dir/config/poshgit_ignore.txt"
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
    $modulesFilePath = "$scriptDir/config/custom_ps_modules.txt"
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