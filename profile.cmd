@echo off

echo "Loading profile.cmd"

color 0b

REM Setting PATH

REM Misc
SET PATH=%PATH%;C:\Program Files\doxygen\bin
SET PATH=%PATH%;C:\Program Files (x86)\Graphviz2.38\bin
SET PATH=%PATH%;C:\Program Files\KDiff3
SET PATH=%PATH%;C:\Program Files\GTK2-Runtime Win64\bin
SET PATH=%PATH%;C:\tools\nuget
SET PATH=%PATH%;C:\tools\Strings

REM General packaging
SET PATH=%PATH%;C:\ProgramData\chocolatey\bin
SET PATH=%PATH%;C:\Users\%USERNAME%\pkgs\bin

REM Git
SET PATH=%PATH%;C:\Program Files\Git\bin
SET PATH=%PATH%;C:\Program Files\Git\usr\bin
SET PATH=%PATH%;C:\Program Files (x86)\Meld

REM Editors
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

REM Useful utility commands
REM DOSKEY igrep=findstr /psinc:$1 $2 $3 $4 $5
DOSKEY grep=grep --color -n $*
DOSKEY sublime=start sublime_text.exe -n $*
DOSKEY editprofile=code %APPDATA%\profile.cmd
DOSKEY sourceprofile=call %APPDATA%\profile.cmd
DOSKEY rmdir=rmdir /q/s $*
DOSKEY clipp=echo|set /p=%CD%|clip
DOSKEY less=less -i $*
DOSKEY home=cd /d C:\users\%USERNAME%\AppData\Roaming\
DOSKEY rcopy=robocopy /E /R:0 $*
DOSKEY emacs=start emacsclient -t $*
DOSKEY fzf=fzf --print0 $* ^| clip
DOSKEY tree=tree /A $* ^| less -i
DOSKEY find=C:\tools\GnuWin32\bin\find.exe $*

REM Alias for running source depot razzle
DOSKEY razzle=%APPDATA%\razzle.cmd $*

REM Setup VS env variables. ***Must be called last***
"C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\VsMSBuildCmd.bat"