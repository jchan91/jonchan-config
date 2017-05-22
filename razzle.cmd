@echo off

set _MY_OUT_DRIVE=D:\
set _MY_OBJ_ROOT=%_MY_OUT_DRIVE%win\%1.obj
set _MY_BIN_ROOT=%_MY_OUT_DRIVE%win\%1.bin
set _MY_PUB_ROOT=%_MY_OUT_DRIVE%win\%1.public
set _MY_ENLISTMENT=%1
set _MY_OBJ_DIR=%_MY_OBJ_ROOT%\%_MY_ENLISTMENT%
set _MY_BIN_DIR=%_MY_BIN_ROOT%\%_MY_ENLISTMENT%
set _MY_PUB_DIR=%_MY_PUB_ROOT%\%_MY_ENLISTMENT%

call E:\win\%_MY_ENLISTMENT%\tools\razzle.cmd dev_build %2 %3 object_dir %_MY_OBJ_DIR% binaries_dir %_MY_BIN_DIR% public_dir %_MY_PUB_DIR% OUTPUT_DRIVE %_MY_OUT_DRIVE%
call %APPDATA%\setenlistenv.bat

CD /D %SDXROOT%
