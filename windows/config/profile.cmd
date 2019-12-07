@echo off

echo "Loading profile.cmd"

set script_dir=%~dp0
echo %script_dir%

REM Set command prompt coloring
REM set PROMPT=$_$E[31m$T$_$E[0:37m$+$E[1;33m$M$E[0:37m$E[1;33m$P$E[0:37m$_$E[0:37m>$S$E[0m
color 0b

REM Setting PATH

REM Misc
SET PATH=%PATH%;C:\Program Files\doxygen\bin
SET PATH=%PATH%;C:\Program Files (x86)\Graphviz2.38\bin
SET PATH=%PATH%;C:\Program Files\KDiff3
SET PATH=%PATH%;C:\Program Files\GTK2-Runtime Win64\bin
SET PATH=%PATH%;C:\ProgramData\tools\nuget
SET PATH=%PATH%;C:\ProgramData\tools\Strings
SET PATH=%PATH%;%script_dir%config\scripts

REM General packaging
SET PATH=%PATH%;C:\ProgramData\chocolatey\bin
SET PATH=%PATH%;C:\Users\%USERNAME%\pkgs\bin

REM Git
SET PATH=%PATH%;C:\Program Files\Git\bin
SET PATH=%PATH%;C:\Program Files\Git\usr\bin
SET PATH=%PATH%;C:\Program Files (x86)\Meld

REM Editors
REM SET PATH=%PATH%;C:\Program Files\Microsoft VS Code\
SET PATH=%PATH%;C:\Program Files\Sublime Text 3\

REM Python stuff
REM SET PYTHON27_PATH=C:\Python27
REM SET PYTHON35_PATH=C:\Users\%USERNAME%\AppData\Local\Programs\Python\Python35
REM SET PYTHON35_SCRIPTS=%PYTHON35_PATH%\Scripts
REM SET PATH=%PATH%;%PYTHON35_PATH%;%PYTHON35_SCRIPTS%
REM SET PYTHONPATH=%PYTHONPATH%;E:\aea\scripts\python
REM DOSKEY python27=%PYTHON27_PATH%\python.exe $*
REM SET PATH=%PATH%;E:\Anaconda3-4.1.1-Windows-x86_64;E:\Anaconda3-4.1.1-Windows-x86_64\Scripts
rem SET PYTHONPATH=C:\ProgramData\Anaconda3;C:\ProgramData\Anaconda3\Scripts
SET CONDA_PATH=C:\ProgramData\Anaconda3\Scripts
SET PATH=%PATH%;%CONDA_PATH%
rem SET PATH=%PATH%;%PYTHONPATH%
DOSKEY ipython=python -m IPython

REM Azure
SET PATH=%PATH%;C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy

REM Android
SET ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk
DOSKEY adb=%ANDROID_HOME%\platform-tools\adb.exe $*

REM Java
SET JAVA_HOME=C:\Program Files\Java\jdk1.8.0_201

REM CMake
SET PATH=%PATH%;C:\Program Files\CMake\bin

REM smerge
SET PATH=%PATH%;C:\Program Files\Sublime Merge

REM Useful utility commands
REM DOSKEY igrep=findstr /psinc:$1 $2 $3 $4 $5
DOSKEY grep=grep --color -n $*
DOSKEY sublime=start sublime_text.exe -n $*
DOSKEY editprofile=sublime_text.exe -n %script_dir%config\profile.cmd
DOSKEY sourceprofile=call %script_dir%config\profile.cmd
DOSKEY rmdir=rmdir /q/s $*
DOSKEY cd=cd /d $*
DOSKEY clipp=echo ^| set /p="%%CD%%" ^| clip
DOSKEY less=less -i $*
DOSKEY home=cd /d %APPDATA%
DOSKEY rcopy=robocopy /E /R:0 $*
DOSKEY emacs=start emacsclient -t $*
DOSKEY fzf=fzf --print0 $* ^| clip
DOSKEY tree=tree /A $* ^| less -i
DOSKEY find=C:\Program Files\Git\usr\bin\find.exe $*

REM Alias for running source depot razzle
DOSKEY razzle=%script_dir%config\razzle.cmd $*

REM Setup VS env variables. ***Must be called last***
IF EXIST "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\VsMSBuildCmd.bat" (
    echo "Loading VS Community Build bat"
    "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\VsMSBuildCmd.bat"
)
IF EXIST "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\Tools\VsMSBuildCmd.bat" (
    echo "Loading VS Enterprise Build bat"
    "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\Tools\VsMSBuildCmd.bat"
)
