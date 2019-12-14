@echo off
setlocal

set ROOT=%~dp0..\..
set CURL=%ROOT%\utils\curl.exe
set UNZIP=%ROOT%\utils\7za.exe
set TMPDIR=%ROOT%\_tmpdir
set ODIR=%ROOT%\_dstdir
set STUB=%ROOT%\stubs

:: ---------------------------------------------------------------------------------------------------------------------
if not exist "%TMPDIR%" mkdir "%TMPDIR%" 2> NUL
if not exist "%ODIR%" mkdir "%ODIR%" 2> NUL

:: ---------------------------------------------------------------------------------------------------------------------
set "ver_mariadb103=10.3.21"
set "ver_mariadb104=10.4.11"

set "url_mariadb103_x64=https://downloads.mariadb.com/MariaDB/mariadb-%ver_mariadb103%/winx64-packages/mariadb-%ver_mariadb103%-winx64.zip"
set "url_mariadb103_x86=https://downloads.mariadb.com/MariaDB/mariadb-%ver_mariadb103%/win32-packages/mariadb-%ver_mariadb103%-win32.zip"

set "url_mariadb104_x64=https://downloads.mariadb.com/MariaDB/mariadb-%ver_mariadb104%/winx64-packages/mariadb-%ver_mariadb104%-winx64.zip"
set "url_mariadb104_x86=https://downloads.mariadb.com/MariaDB/mariadb-%ver_mariadb104%/win32-packages/mariadb-%ver_mariadb104%-win32.zip"

:: MariaDB 10.3 x64 ----------------------------------------------------------------------------------------------------
if not exist "%TMPDIR%\mariadb-%ver_mariadb103%-x64.zip" (
    echo. && echo ^> Downloading MariaDB v%ver_mariadb103% x64 ... && %CURL% -L# %url_mariadb103_x64% -o "%TMPDIR%\mariadb-%ver_mariadb103%-x64.zip"
)
if exist "%TMPDIR%\mariadb-%ver_mariadb103%-x64.zip" (
    echo. && echo ^> Extracting MariaDB v%ver_mariadb103% x64 ...
    if exist "%ODIR%\mariadb-10.3-x64" RD /S /Q "%ODIR%\mariadb-10.3-x64"
    %UNZIP% x "%TMPDIR%\mariadb-%ver_mariadb103%-x64.zip" -o"%ODIR%" -y > nul
    RD /S /Q "%ODIR%\mariadb-%ver_mariadb103%-winx64\data"
    ren "%ODIR%\mariadb-%ver_mariadb103%-winx64" mariadb-10.3-x64
    copy /Y "%STUB%\mariadb.ini" "%ODIR%\mariadb-10.3-x64\my.ini" > nul
)

:: MariaDB 10.3 x86 ----------------------------------------------------------------------------------------------------
if not exist "%TMPDIR%\mariadb-%ver_mariadb103%-x86.zip" (
    echo. && echo ^> Downloading MariaDB v%ver_mariadb103% x86 ... && %CURL% -L# %url_mariadb103_x86% -o "%TMPDIR%\mariadb-%ver_mariadb103%-x86.zip"
)
if exist "%TMPDIR%\mariadb-%ver_mariadb103%-x86.zip" (
    echo. && echo ^> Extracting MariaDB v%ver_mariadb103% x86 ...
    if exist "%ODIR%\mariadb-10.3-x86" RD /S /Q "%ODIR%\mariadb-10.3-x86"
    %UNZIP% x "%TMPDIR%\mariadb-%ver_mariadb103%-x86.zip" -o"%ODIR%" -y > nul
    RD /S /Q "%ODIR%\mariadb-%ver_mariadb103%-win32\data"
    ren "%ODIR%\mariadb-%ver_mariadb103%-win32" mariadb-10.3-x86
    copy /Y "%STUB%\mariadb.ini" "%ODIR%\mariadb-10.3-x86\my.ini" > nul
)

:: MariaDB 10.4 x64 ----------------------------------------------------------------------------------------------------
if not exist "%TMPDIR%\mariadb-%ver_mariadb104%-x64.zip" (
    echo. && echo ^> Downloading MariaDB v%ver_mariadb104% x64 ... && %CURL% -L# %url_mariadb104_x64% -o "%TMPDIR%\mariadb-%ver_mariadb104%-x64.zip"
)
if exist "%TMPDIR%\mariadb-%ver_mariadb104%-x64.zip" (
    echo. && echo ^> Extracting MariaDB v%ver_mariadb104% x64 ...
    if exist "%ODIR%\mariadb-10.4-x64" RD /S /Q "%ODIR%\mariadb-10.4-x64"
    %UNZIP% x "%TMPDIR%\mariadb-%ver_mariadb104%-x64.zip" -o"%ODIR%" -y > nul
    RD /S /Q "%ODIR%\mariadb-%ver_mariadb104%-winx64\data"
    ren "%ODIR%\mariadb-%ver_mariadb104%-winx64" mariadb-10.4-x64
    copy /Y "%STUB%\mariadb.ini" "%ODIR%\mariadb-10.4-x64\my.ini" > nul
)

:: MariaDB 10.4 x86 ----------------------------------------------------------------------------------------------------
if not exist "%TMPDIR%\mariadb-%ver_mariadb104%-x86.zip" (
    echo. && echo ^> Downloading MariaDB v%ver_mariadb104% x86 ... && %CURL% -L# %url_mariadb104_x86% -o "%TMPDIR%\mariadb-%ver_mariadb104%-x86.zip"
)
if exist "%TMPDIR%\mariadb-%ver_mariadb104%-x86.zip" (
    echo. && echo ^> Extracting MariaDB v%ver_mariadb104% x86 ...
    if exist "%ODIR%\mariadb-10.4-x86" RD /S /Q "%ODIR%\mariadb-10.4-x86"
    %UNZIP% x "%TMPDIR%\mariadb-%ver_mariadb104%-x86.zip" -o"%ODIR%" -y > nul
    RD /S /Q "%ODIR%\mariadb-%ver_mariadb104%-win32\data"
    ren "%ODIR%\mariadb-%ver_mariadb104%-win32" mariadb-10.4-x86
    copy /Y "%STUB%\mariadb.ini" "%ODIR%\mariadb-10.4-x86\my.ini" > nul
)

:: Cleanup residual files ------------------------------------------------------------------------------------------------
echo. && echo ^> Cleanup residual files ... && forfiles /p "%ODIR%" /s /m *.pdb /d -1 /c "cmd /c del /F @file"
echo ^> All files already downloaded! && echo.
