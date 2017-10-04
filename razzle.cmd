@echo off

set scriptDir=%~dp0

set _MY_ENLISTMENT=%1

REM set _MY_OUT_DRIVE=D:\
REM set _MY_OBJ_ROOT=%_MY_OUT_DRIVE%win\%1.obj
REM set _MY_BIN_ROOT=%_MY_OUT_DRIVE%win\%1.bin
REM set _MY_PUB_ROOT=%_MY_OUT_DRIVE%win\%1.public
REM set _MY_OBJ_DIR=%_MY_OBJ_ROOT%\%_MY_ENLISTMENT%
REM set _MY_BIN_DIR=%_MY_BIN_ROOT%\%_MY_ENLISTMENT%
REM set _MY_PUB_DIR=%_MY_PUB_ROOT%\%_MY_ENLISTMENT%

call J:\%_MY_ENLISTMENT%\src\tools\razzle.cmd dev_build %2 %3
call %scriptDir%\setenlistenv.bat

CD /D %SDXROOT%
