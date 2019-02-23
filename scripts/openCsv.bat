@ECHO OFF

set "scriptDir=%~dp0"
set "openCsvPs1Cmd=%scriptDir%openCsv.ps1"

start powershell %openCsvPs1Cmd% %*