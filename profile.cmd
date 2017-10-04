@echo off

color 0b

REM Setting Common PATH variables
SET PATH=%PATH%;C:\Users\jonchan\pkgs\bin
SET PATH=%PATH%;C:\Program Files (x86)\Notepad++
SET PATH=%PATH%;C:\Program Files\Sublime Text 3
SET PATH=%PATH%;C:\Program Files\Git\bin
SET PATH=%PATH%;C:\Program Files\Git\usr\bin
SET PATH=%PATH%;C:\Program Files (x86)\Microsoft SDKs\Windows\v8.1A\bin\NETFX 4.5.1 Tools
SET PATH=%PATH%;C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin
SET PATH=%PATH%;C:\build\boost_1_57_0\bin
SET PATH=%PATH%;C:\Program Files (x86)\Meld
SET PATH=%PATH%;C:\Program Files\doxygen\bin
SET PATH=%PATH%;C:\Program Files (x86)\Graphviz2.38\bin
SET PATH=%PATH%;C:\Program Files\KDiff3
SET PATH=%PATH%;C:\Program Files\GTK2-Runtime Win64\bin

REM Python stuff
REM SET PYTHON27_PATH=C:\Python27
REM SET PYTHON35_PATH=C:\Users\%USERNAME%\AppData\Local\Programs\Python\Python35
REM SET PYTHON35_SCRIPTS=%PYTHON35_PATH%\Scripts
REM SET PATH=%PATH%;%PYTHON35_PATH%;%PYTHON35_SCRIPTS%
REM SET PYTHONPATH=%PYTHONPATH%;E:\aea\scripts\python
REM DOSKEY python27=%PYTHON27_PATH%\python.exe $*
SET PATH=%PATH%;E:\Anaconda3-4.1.1-Windows-x86_64;E:\Anaconda3-4.1.1-Windows-x86_64\Scripts

REM Useful utility commands
DOSKEY igrep=findstr /psinc:$1 $2 $3 $4 $5
DOSKEY gitlog=git log --pretty=format:"%C(yellow)%h%Cred%d%Creset - %C(cyan)%an %Creset: %s %Cgreen(%cr)" --graph
DOSKEY npp=notepad++.exe $1
DOSKEY sublime=start sublime_text.exe -n $*
DOSKEY emacs=start emacs $*
DOSKEY editprofile=sublime_text.exe -n C:\Users\%USERNAME%\AppData\Roaming\profile.cmd
DOSKEY sourceprofile=call C:\Users\%USERNAME%\AppData\Roaming\profile.cmd
DOSKEY rmdir=rmdir /q/s $*
DOSKEY clipp=echo|set /p=%CD%|clip
DOSKEY less=less -i $*
DOSKEY home=cd /d C:\users\%USERNAME%\AppData\Roaming\
DOSKEY rcopy=robocopy /E /R:0 $*

REM Spline tools
DOSKEY plots=start python E:\aea\scripts\python\plot_spline.py -i $*
DOSKEY render=python E:\aea\scripts\python\render.py -t $1 -s $2

REM Add MSVC variables to run stuff like cl.exe from Command Line
REM call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" x86

REM ROS stuff
DOSKEY hydro=call C:\opt\ros\hydro\x86\setup.bat
DOSKEY fuerte=call C:\opt\ros\fuerte\x86\env.bat

REM Useful SD commands
DOSKEY objrt=cd /d $3:\win\$1.obj\$1.$2\analog
DOSKEY binrt=cd /d $3:\win\$1.bin\$1.$2\Analog\bin
DOSKEY tstrt=cd /d $3:\win\$1.bin\$1.$2\test_automation_bins\Analog\bin
DOSKEY sdb=E:\tools\sdb\sdb.exe $*

REM Mount common network drives
if NOT exist Z: net use Z: \\analogfs\private\Scratch\JONCHAN
if NOT exist Y: net use Y: \\analogfs\private\AnalogPlat\analogsyndata
if NOT exist X: net use X: \\analogfs\private\AnalogPlat

REM Alias for running source depot razzle
DOSKEY razzle=%APPDATA%\razzle.cmd $*

REM Arnold
set solidangle_LICENSE=49000@rlmarnold.cloudapp.net