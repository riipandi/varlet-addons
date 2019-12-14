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
set "ver_pgsql96=9.6.16-2"
set "ver_pgsql10=10.11-3"
set "ver_pgsql11=11.6-3"
set "ver_pgsql12=12.1-1"

set "url_pgsql96_x64=http://get.enterprisedb.com/postgresql/postgresql-%ver_pgsql96%-windows-x64-binaries.zip"
set "url_pgsql96_x86=http://get.enterprisedb.com/postgresql/postgresql-%ver_pgsql96%-windows-binaries.zip"

set "url_pgsql10_x64=https://get.enterprisedb.com/postgresql/postgresql-%ver_pgsql10%-windows-x64-binaries.zip"
set "url_pgsql10_x86=https://get.enterprisedb.com/postgresql/postgresql-%ver_pgsql10%-windows-binaries.zip"

set "url_pgsql11_x64=https://get.enterprisedb.com/postgresql/postgresql-%ver_pgsql11%-windows-x64-binaries.zip"
set "url_pgsql12_x64=https://get.enterprisedb.com/postgresql/postgresql-%ver_pgsql12%-windows-x64-binaries.zip"

:: PostgreSQL 9.6 x64 ----------------------------------------------------------------------------------------------------
if not exist "%TMPDIR%\pgsql-%ver_pgsql96%-x64.zip" (
    echo. && echo ^> Downloading pgsql v%ver_pgsql96% x64 ... && %CURL% -L# %url_pgsql96_x64% -o "%TMPDIR%\pgsql-%ver_pgsql96%-x64.zip"
)
if exist "%TMPDIR%\pgsql-%ver_pgsql96%-x64.zip" (
    echo. && echo ^> Extracting PostgreSQL v%ver_pgsql96% x64 ...
    if exist "%ODIR%\pgsql-9.6-x64" RD /S /Q "%ODIR%\pgsql-9.6-x64"
    %UNZIP% x "%TMPDIR%\pgsql-%ver_pgsql96%-x64.zip" -o"%ODIR%" -y > nul
    ren "%ODIR%\pgsql" pgsql-9.6-x64
    RD /S /Q "%ODIR%\pgsql-9.6-x64\pgAdmin 4"
    RD /S /Q "%ODIR%\pgsql-9.6-x64\StackBuilder"
    RD /S /Q "%ODIR%\pgsql-9.6-x64\symbols"
)

:: PostgreSQL 9.6 x86 ----------------------------------------------------------------------------------------------------
if not exist "%TMPDIR%\pgsql-%ver_pgsql96%-x86.zip" (
    echo. && echo ^> Downloading pgsql v%ver_pgsql96% x86 ... && %CURL% -L# %url_pgsql96_x86% -o "%TMPDIR%\pgsql-%ver_pgsql96%-x86.zip"
)
if exist "%TMPDIR%\pgsql-%ver_pgsql96%-x86.zip" (
    echo. && echo ^> Extracting PostgreSQL v%ver_pgsql96% x86 ...
    if exist "%ODIR%\pgsql-9.6-x86" RD /S /Q "%ODIR%\pgsql-9.6-x86"
    %UNZIP% x "%TMPDIR%\pgsql-%ver_pgsql96%-x86.zip" -o"%ODIR%" -y > nul
    ren "%ODIR%\pgsql" pgsql-9.6-x86
    RD /S /Q "%ODIR%\pgsql-9.6-x86\pgAdmin 4"
    RD /S /Q "%ODIR%\pgsql-9.6-x86\StackBuilder"
    RD /S /Q "%ODIR%\pgsql-9.6-x86\symbols"
)

:: PostgreSQL 10 x64 ----------------------------------------------------------------------------------------------------
if not exist "%TMPDIR%\pgsql-%ver_pgsql10%-x64.zip" (
    echo. && echo ^> Downloading pgsql v%ver_pgsql10% x64 ... && %CURL% -L# %url_pgsql10_x64% -o "%TMPDIR%\pgsql-%ver_pgsql10%-x64.zip"
)
if exist "%TMPDIR%\pgsql-%ver_pgsql10%-x64.zip" (
    echo. && echo ^> Extracting PostgreSQL v%ver_pgsql10% x64 ...
    if exist "%ODIR%\pgsql-10-x64" RD /S /Q "%ODIR%\pgsql-10-x64"
    %UNZIP% x "%TMPDIR%\pgsql-%ver_pgsql10%-x64.zip" -o"%ODIR%" -y > nul
    ren "%ODIR%\pgsql" pgsql-10-x64
    RD /S /Q "%ODIR%\pgsql-10-x64\pgAdmin 4"
    RD /S /Q "%ODIR%\pgsql-10-x64\StackBuilder"
    RD /S /Q "%ODIR%\pgsql-10-x64\symbols"
)

:: PostgreSQL 10 x86 ----------------------------------------------------------------------------------------------------
if not exist "%TMPDIR%\pgsql-%ver_pgsql10%-x86.zip" (
    echo. && echo ^> Downloading pgsql v%ver_pgsql10% x86 ... && %CURL% -L# %url_pgsql10_x86% -o "%TMPDIR%\pgsql-%ver_pgsql10%-x86.zip"
)
if exist "%TMPDIR%\pgsql-%ver_pgsql10%-x86.zip" (
    echo. && echo ^> Extracting PostgreSQL v%ver_pgsql10% x86 ...
    if exist "%ODIR%\pgsql-10-x86" RD /S /Q "%ODIR%\pgsql-10-x86"
    %UNZIP% x "%TMPDIR%\pgsql-%ver_pgsql10%-x86.zip" -o"%ODIR%" -y > nul
    ren "%ODIR%\pgsql" pgsql-10-x86
    RD /S /Q "%ODIR%\pgsql-10-x86\pgAdmin 4"
    RD /S /Q "%ODIR%\pgsql-10-x86\StackBuilder"
    RD /S /Q "%ODIR%\pgsql-10-x86\symbols"
)

:: PostgreSQL 11 x64 ----------------------------------------------------------------------------------------------------
if not exist "%TMPDIR%\pgsql-%ver_pgsql11%-x64.zip" (
    echo. && echo ^> Downloading pgsql v%ver_pgsql11% x64 ... && %CURL% -L# %url_pgsql11_x64% -o "%TMPDIR%\pgsql-%ver_pgsql11%-x64.zip"
)
if exist "%TMPDIR%\pgsql-%ver_pgsql11%-x64.zip" (
    echo. && echo ^> Extracting PostgreSQL v%ver_pgsql11% x64 ...
    if exist "%ODIR%\pgsql-11-x64" RD /S /Q "%ODIR%\pgsql-11-x64"
    %UNZIP% x "%TMPDIR%\pgsql-%ver_pgsql11%-x64.zip" -o"%ODIR%" -y > nul
    ren "%ODIR%\pgsql" pgsql-11-x64
    RD /S /Q "%ODIR%\pgsql-11-x64\pgAdmin 4"
    RD /S /Q "%ODIR%\pgsql-11-x64\StackBuilder"
    RD /S /Q "%ODIR%\pgsql-11-x64\symbols"
)

:: PostgreSQL 12 x64 ----------------------------------------------------------------------------------------------------
if not exist "%TMPDIR%\pgsql-%ver_pgsql12%-x64.zip" (
    echo. && echo ^> Downloading pgsql v%ver_pgsql12% x64 ... && %CURL% -L# %url_pgsql12_x64% -o "%TMPDIR%\pgsql-%ver_pgsql12%-x64.zip"
)
if exist "%TMPDIR%\pgsql-%ver_pgsql12%-x64.zip" (
    echo. && echo ^> Extracting PostgreSQL v%ver_pgsql12% x64 ...
    if exist "%ODIR%\pgsql-12-x64" RD /S /Q "%ODIR%\pgsql-12-x64"
    %UNZIP% x "%TMPDIR%\pgsql-%ver_pgsql12%-x64.zip" -o"%ODIR%" -y > nul
    ren "%ODIR%\pgsql" pgsql-12-x64
    RD /S /Q "%ODIR%\pgsql-12-x64\pgAdmin 4"
    RD /S /Q "%ODIR%\pgsql-12-x64\StackBuilder"
    RD /S /Q "%ODIR%\pgsql-12-x64\symbols"
)

:: Cleanup residual files ------------------------------------------------------------------------------------------------
echo. && echo Cleanup residual files ...
REM forfiles /p "%ODIR%" /s /m *.pdb /d -1 /c "cmd /c del /F @file"
echo. && echo All files already downloaded! && echo.
