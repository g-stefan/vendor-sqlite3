@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

echo -^> vendor vendor-sqlite3

if not exist archive\ mkdir archive

pushd archive
set VENDOR=sqlite3-3.33.0
set WEB_LINK=https://www.sqlite.org/2020/sqlite-amalgamation-3330000.zip
if not exist %VENDOR%.zip curl --insecure --location %WEB_LINK% --output %VENDOR%.zip
7z x %VENDOR%.zip -aoa -o.
del /F /Q %VENDOR%.zip
if exist %VENDOR%.7z del /F /Q %VENDOR%.7z
move sqlite-amalgamation-3330000 sqlite3-3.33.0
7zr a -mx9 -mmt4 -r- -sse -w. -y -t7z %VENDOR%.7z %VENDOR%
rmdir /Q /S %VENDOR%
popd
