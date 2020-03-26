@ECHO OFF

REM See https://social.technet.microsoft.com/Forums/ie/en-US/06d35f90-56cb-4dec-b326-bd471d06acee/change-default-program-for-file-command-line-or-registry?forum=w7itprogeneral

set "scriptDir=%~dp0"

REM Text Files
REM set "openTxtScriptPath=%scriptDir%sublime.cmd"
set "openTxtScriptPath=%scriptDir%vscode.cmd"
ftype txtfile=%openTxtScriptPath% "%%1"

REM CSV Files
set "openCsvScriptPath=%scriptDir%openCsv.bat"
ftype csvfile=%openCsvScriptPath% "%%1"
assoc .csv=csvfile
