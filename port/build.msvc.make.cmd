@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

set ACTION=%1
if "%1" == "" set ACTION=make

echo -^> %ACTION% vendor-sqlite3

goto StepX
:cmdX
%*
if errorlevel 1 goto cmdXError
goto :eof
:cmdXError
echo "Error: %ACTION%"
exit 1
:StepX

call :cmdX xyo-cc --mode=%ACTION% --source-has-archive sqlite3

if not exist include\ mkdir include
if not exist include\sqlite3.h copy source\sqlite3.h include\sqlite3.h
if not exist include\sqlite3ext.h copy source\sqlite3ext.h include\sqlite3ext.h

call :cmdX xyo-cc --mode=%ACTION% @util/libsqlite3.static.compile
call :cmdX xyo-cc --mode=%ACTION% @util/libsqlite3.dynamic.compile
call :cmdX xyo-cc --mode=%ACTION% @util/sqlite3.compile
