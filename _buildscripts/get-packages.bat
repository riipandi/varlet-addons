@echo off

set UNZIP=%~dp0..\_buildtools\7za.exe
set CURL=%~dp0..\_buildtools\curl.exe
set ODIR=%~dp0..\packages
set STUB=%~dp0..\stubs

:: Packages version
set "MariaDBversion=10.4.8"

:: Download link
set "URL_MARIADB=https://downloads.mariadb.com/MariaDB/mariadb-%MariaDBversion%/winx64-packages/mariadb-%MariaDBversion%-winx64.zip"
set "VCREDIST_2012=http://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe"
set "VCREDIST_1519=https://aka.ms/vs/16/release/VC_redist.x64.exe"

:: Main components
:: -----------------------------------------------------------------------------------------------

if not exist "%ODIR%" mkdir "%ODIR%" 2> NUL

:: VCRedist 2012 + 2015-2019
if not exist "%ODIR%\vcredis\" (
    echo. && echo Downloading Visual C++ Redistributable ...
    if not exist "%ODIR%\vcredis" mkdir "%ODIR%\vcredis" 2> NUL
    %CURL% -L# %VCREDIST_2012% -o "%ODIR%\vcredis\vcredis2012x64.exe"
    %CURL% -L# %VCREDIST_1519% -o "%ODIR%\vcredis\vcredis1519x64.exe"
)

if not exist "%TMP%\mariadb-%MariaDBversion%.zip" (
    echo. && echo Downloading MariaDB v%MariaDBversion% ...
    %CURL% -L# %URL_MARIADB% -o "%TMP%\mariadb-%MariaDBversion%.zip"
)
if exist "%TMP%\mariadb-%MariaDBversion%.zip" (
    echo. && echo Extracting MariaDB v%MariaDBversion% ...
    if exist "%ODIR%\mariadb" RD /S /Q "%ODIR%\mariadb"
    %UNZIP% x "%TMP%\mariadb-%MariaDBversion%.zip" -o"%ODIR%" -y > nul
    RD /S /Q "%ODIR%\mariadb-%MariaDBversion%-winx64\data"
    ren "%ODIR%\mariadb-%MariaDBversion%-winx64" mariadb
    copy /Y "%STUB%\my.ini" "%ODIR%\mariadb\my.ini" > nul
)

:: Cleanup unused files
:: -----------------------------------------------------------------------------------------------
echo. && echo Cleanup unused files ...
forfiles /p "%ODIR%" /s /m *.pdb /d -1 /c "cmd /c del /F @file"

:: Done!
:: -----------------------------------------------------------------------------------------------

echo. && echo All files already downloaded!
pause
