@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

echo -^> release vendor-sqlite3

goto cmdXDefined
:cmdX
%*
if errorlevel 1 goto cmdXError
goto :eof
:cmdXError
echo "Error: release"
exit 1
:cmdXDefined

set XYO_PATH_RELEASE=release

call :cmdX cmd.exe /C build\msvc.cmd make
call :cmdX cmd.exe /C build\msvc.cmd sign
call :cmdX cmd.exe /C build\msvc.cmd install
call :cmdX cmd.exe /C build\msvc.cmd install-release
call :cmdX xyo-cc sqlite3 --archive-release-sha512 --version-file=version.ini
