@echo off

echo "Loading profile.cmd"

color 0b

REM Setting Common PATH variables
SET PATH=%PATH%;C:\Users\%USERNAME%\pkgs\bin
SET PATH=%PATH%;C:\Program Files\Sublime Text 3
SET PATH=%PATH%;C:\Program Files\Git\bin
SET PATH=%PATH%;C:\Program Files\Git\usr\bin
SET PATH=%PATH%;C:\Program Files (x86)\Microsoft SDKs\Windows\v8.1A\bin\NETFX 4.5.1 Tools
SET PATH=%PATH%;C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin
SET PATH=%PATH%;C:\Program Files (x86)\Meld
SET PATH=%PATH%;C:\Program Files\doxygen\bin
SET PATH=%PATH%;C:\Program Files (x86)\Graphviz2.38\bin
SET PATH=%PATH%;C:\Program Files\KDiff3
SET PATH=%PATH%;C:\Program Files\GTK2-Runtime Win64\bin
SET PATH=%PATH%;E:\tools\Strings

REM Python stuff
REM SET PYTHON27_PATH=C:\Python27
REM SET PYTHON35_PATH=C:\Users\%USERNAME%\AppData\Local\Programs\Python\Python35
REM SET PYTHON35_SCRIPTS=%PYTHON35_PATH%\Scripts
REM SET PATH=%PATH%;%PYTHON35_PATH%;%PYTHON35_SCRIPTS%
REM SET PYTHONPATH=%PYTHONPATH%;E:\aea\scripts\python
REM DOSKEY python27=%PYTHON27_PATH%\python.exe $*
REM SET PATH=%PATH%;E:\Anaconda3-4.1.1-Windows-x86_64;E:\Anaconda3-4.1.1-Windows-x86_64\Scripts
SET PATH=%PATH%;C:\ProgramData\Anaconda3;C:\ProgramData\Anaconda3\Scripts

REM Useful utility commands
DOSKEY igrep=findstr /psinc:$1 $2 $3 $4 $5
DOSKEY sublime=start sublime_text.exe -n $*
DOSKEY emacs=start emacs $*
DOSKEY editprofile=sublime_text.exe -n %APPDATA%\profile.cmd
DOSKEY sourceprofile=call %APPDATA%\profile.cmd
DOSKEY rmdir=rmdir /q/s $*
DOSKEY clipp=echo|set /p=%CD%|clip
DOSKEY less=less -i $*
DOSKEY home=cd /d C:\users\%USERNAME%\AppData\Roaming\
DOSKEY rcopy=robocopy /E /R:0 $*

REM Add MSVC variables to run stuff like cl.exe from Command Line
REM call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" x86

REM Useful SD commands
DOSKEY objrt=cd /d $J:\os\src.obj.$1\analog
DOSKEY binrt=cd /d $J:\os\src.binanires.$1\Analog\bin
DOSKEY tstrt=cd /d $J:\os\src.binanires.$1\test_automation_bins\Analog\bin
DOSKEY sdb=E:\tools\sdb\sdb.exe $*

REM Mount common network drives
if %COMPUTERNAME%==JONCHAN-DESKTOP (
	if NOT exist Z: net use Z: \\analogfs\private\Scratch\JONCHAN
	if NOT exist Y: net use Y: \\analogfs\private\AnalogPlat\analogsyndata
	if NOT exist X: net use X: \\analogfs\private\AnalogPlat
)

REM Alias for running source depot razzle
DOSKEY razzle=%APPDATA%\razzle.cmd $*

REM Arnold
set solidangle_LICENSE=49000@rlmarnold.cloudapp.net