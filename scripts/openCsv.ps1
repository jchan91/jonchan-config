param (
    [string]$csvPath
)

Import-Csv $csvPath | Out-GridView -Title $csvPath
