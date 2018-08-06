@echo off

echo "Loading profile.cmd"

color 0b

REM Setting PATH

REM Misc
SET PATH=%PATH%;C:\Program Files\doxygen\bin
SET PATH=%PATH%;C:\Program Files (x86)\Graphviz2.38\bin
SET PATH=%PATH%;C:\Program Files\KDiff3
SET PATH=%PATH%;C:\Program Files\GTK2-Runtime Win64\bin
SET PATH=%PATH%;%USERPROFILE%\.nuget\packages\nuget.commandline\3.5.0\tools\
SET PATH=%PATH%;C:\tools\Strings

REM General packaging
SET PATH=%PATH%;C:\ProgramData\chocolatey\bin
SET PATH=%PATH%;C:\Users\%USERNAME%\pkgs\bin

REM Git
SET PATH=%PATH%;C:\Program Files\Git\bin
SET PATH=%PATH%;C:\Program Files\Git\usr\bin
SET PATH=%PATH%;C:\Program Files (x86)\Meld

REM Editors
SET PATH=%PATH%;C:\Program Files\Microsoft VS Code\
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

REM Add MSVC variables to run stuff like cl.exe from Command Line
REM call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" x86

REM Useful SD commands
DOSKEY objrt=cd /d G:\os\obj\$1\analog
DOSKEY binrt=cd /d G:\os\bin\$1\Analog\bin
DOSKEY tstrt=cd /d G:\os\bin\$1\test_automation_bins\Analog\bin
DOSKEY sdb=E:\tools\sdb\sdb.exe $*

REM Mount common network drives
if %COMPUTERNAME%==JONCHAN-DESKTOP (
	if NOT exist Z: net use Z: \\analogfs\private\Scratch\JONCHAN
	if NOT exist Y: net use Y: \\analogfs\PRIVATE\Science\ReposeData\ReposeDataServerV1\Datasets
	if NOT exist X: net use X: \\analogfs\private\AnalogPlat
)

REM Alias for running source depot razzle
DOSKEY razzle=%APPDATA%\razzle.cmd $*

REM Arnold
set solidangle_LICENSE=49000@rlmarnold.cloudapp.net

REM MSVC Tools
REM SET PATH=%PATH%;C:\Windows\Microsoft.NET\Framework\v4.0.30319\
REM SET PATH=%PATH%;C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\VC\Tools\MSVC\14.13.26128\bin\Hostx86\x86\
REM SET PATH=%PATH%;C:\Program Files (x86)\Microsoft SDKs\Windows\v8.1A\bin\NETFX 4.5.1 Tools
REM SET PATH=%PATH%;C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\VC\Tools\MSVC\14.12.25827\bin\Hostx86\x86

REM Setup VS env variables. ***Must be called last***
"C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\Tools\VsMSBuildCmd.bat"