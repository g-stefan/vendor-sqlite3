@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

set ACTION=%1
if "%1" == "" set ACTION=make

echo - %BUILD_PROJECT% ^> %1

goto cmdXDefined
:cmdX
%*
if errorlevel 1 goto cmdXError
goto :eof
:cmdXError
echo "Error: %ACTION%"
exit 1
:cmdXDefined

call :cmdX xyo-cc --mode=%ACTION% --source-has-archive sqlite3

if not exist output\ mkdir output
if not exist output\include\ mkdir output\include
if not exist output\include\sqlite3.h copy source\sqlite3.h output\include\sqlite3.h
if not exist output\include\sqlite3ext.h copy source\sqlite3ext.h output\include\sqlite3ext.h

call :cmdX xyo-cc --mode=%ACTION% @build/source/libsqlite3.static.compile
call :cmdX xyo-cc --mode=%ACTION% @build/source/libsqlite3.dynamic.compile
call :cmdX xyo-cc --mode=%ACTION% @build/source/sqlite3.compile
