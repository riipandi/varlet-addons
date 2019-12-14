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
set "ver_mysql56=5.6.46"
set "ver_mysql57=5.7.28"
set "ver_mysql80=8.0.18"

set "url_mysql56_x64=https://cdn.mysql.com/Downloads/MySQL-5.6/mysql-%ver_mysql56%-winx64.zip"
set "url_mysql56_x86=https://cdn.mysql.com/Downloads/MySQL-5.6/mysql-%ver_mysql56%-win32.zip"

set "url_mysql57_x64=https://cdn.mysql.com/Downloads/MySQL-5.7/mysql-%ver_mysql57%-winx64.zip"
set "url_mysql57_x86=https://cdn.mysql.com/Downloads/MySQL-5.7/mysql-%ver_mysql57%-win32.zip"

set "url_mysql80_x64=https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-%ver_mysql80%-winx64.zip"
set "url_mysql80_x86=https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-%ver_mysql80%.zip"

:: MySQL 5.6 x64 ----------------------------------------------------------------------------------------------------
if not exist "%TMPDIR%\mysql-%ver_mysql56%-x64.zip" (
    echo. && echo ^> Downloading MySQL v%ver_mysql56% x64 ... && %CURL% -L# %url_mysql56_x64% -o "%TMPDIR%\mysql-%ver_mysql56%-x64.zip"
)
if exist "%TMPDIR%\mysql-%ver_mysql56%-x64.zip" (
    echo. && echo ^> Extracting mysql v%ver_mysql56% x64 ...
    if exist "%ODIR%\mysql-5.6-x64" RD /S /Q "%ODIR%\mysql-5.6-x64"
    %UNZIP% x "%TMPDIR%\mysql-%ver_mysql56%-x64.zip" -o"%ODIR%" -y > nul
    ren "%ODIR%\mysql-%ver_mysql56%-winx64" mysql-5.6-x64
    copy /Y "%STUB%\mysql5.ini" "%ODIR%\mysql-5.6-x64\my.ini" > nul
    RD /S /Q "%ODIR%\mysql-5.6-x64\include"
    RD /S /Q "%ODIR%\mysql-5.6-x64\lib\debug"
    RD /S /Q "%ODIR%\mysql-5.6-x64\lib\plugin\debug"
    RD /S /Q "%ODIR%\mysql-5.6-x64\mysql-test"
    RD /S /Q "%ODIR%\mysql-5.6-x64\scripts"
    RD /S /Q "%ODIR%\mysql-5.6-x64\sql-bench"
)

:: MySQL 5.6 x86 ----------------------------------------------------------------------------------------------------
if not exist "%TMPDIR%\mysql-%ver_mysql56%-x86.zip" (
    echo. && echo ^> Downloading MySQL v%ver_mysql56% x86 ... && %CURL% -L# %url_mysql56_x86% -o "%TMPDIR%\mysql-%ver_mysql56%-x86.zip"
)
if exist "%TMPDIR%\mysql-%ver_mysql56%-x86.zip" (
    echo. && echo ^> Extracting mysql v%ver_mysql56% x86 ...
    if exist "%ODIR%\mysql-5.6-x86" RD /S /Q "%ODIR%\mysql-5.6-x86"
    %UNZIP% x "%TMPDIR%\mysql-%ver_mysql56%-x86.zip" -o"%ODIR%" -y > nul
    ren "%ODIR%\mysql-%ver_mysql56%-win32" mysql-5.6-x86
    copy /Y "%STUB%\mysql5.ini" "%ODIR%\mysql-5.6-x86\my.ini" > nul
    RD /S /Q "%ODIR%\mysql-5.6-x86\include"
    RD /S /Q "%ODIR%\mysql-5.6-x86\lib\debug"
    RD /S /Q "%ODIR%\mysql-5.6-x86\lib\plugin\debug"
    RD /S /Q "%ODIR%\mysql-5.6-x86\mysql-test"
    RD /S /Q "%ODIR%\mysql-5.6-x86\scripts"
    RD /S /Q "%ODIR%\mysql-5.6-x86\sql-bench"
)

:: MySQL 5.7 x64 ----------------------------------------------------------------------------------------------------
if not exist "%TMPDIR%\mysql-%ver_mysql57%-x64.zip" (
    echo. && echo ^> Downloading MySQL v%ver_mysql57% x64 ... && %CURL% -L# %url_mysql57_x64% -o "%TMPDIR%\mysql-%ver_mysql57%-x64.zip"
)
if exist "%TMPDIR%\mysql-%ver_mysql57%-x64.zip" (
    echo. && echo ^> Extracting mysql v%ver_mysql57% x64 ...
    if exist "%ODIR%\mysql-5.7-x64" RD /S /Q "%ODIR%\mysql-5.7-x64"
    %UNZIP% x "%TMPDIR%\mysql-%ver_mysql57%-x64.zip" -o"%ODIR%" -y > nul
    ren "%ODIR%\mysql-%ver_mysql57%-winx64" mysql-5.7-x64
    copy /Y "%STUB%\mysql5.ini" "%ODIR%\mysql-5.7-x64\my.ini" > nul
    RD /S /Q "%ODIR%\mysql-5.7-x64\include"
    RD /S /Q "%ODIR%\mysql-5.7-x64\lib\plugin\debug"
)

:: MySQL 5.7 x86 ----------------------------------------------------------------------------------------------------
if not exist "%TMPDIR%\mysql-%ver_mysql57%-x86.zip" (
    echo. && echo ^> Downloading MySQL v%ver_mysql57% x86 ... && %CURL% -L# %url_mysql57_x86% -o "%TMPDIR%\mysql-%ver_mysql57%-x86.zip"
)
if exist "%TMPDIR%\mysql-%ver_mysql57%-x86.zip" (
    echo. && echo ^> Extracting mysql v%ver_mysql57% x86 ...
    if exist "%ODIR%\mysql-5.7-x86" RD /S /Q "%ODIR%\mysql-5.7-x86"
    %UNZIP% x "%TMPDIR%\mysql-%ver_mysql57%-x86.zip" -o"%ODIR%" -y > nul
    ren "%ODIR%\mysql-%ver_mysql57%-win32" mysql-5.7-x86
    copy /Y "%STUB%\mysql5.ini" "%ODIR%\mysql-5.7-x86\my.ini" > nul
    RD /S /Q "%ODIR%\mysql-5.7-x86\include"
    RD /S /Q "%ODIR%\mysql-5.7-x86\lib\plugin\debug"
)

:: MySQL 8.0 x64 ----------------------------------------------------------------------------------------------------
if not exist "%TMPDIR%\mysql-%ver_mysql80%-x64.zip" (
    echo. && echo ^> Downloading MySQL v%ver_mysql80% x64 ... && %CURL% -L# %url_mysql80_x64% -o "%TMPDIR%\mysql-%ver_mysql80%-x64.zip"
)
if exist "%TMPDIR%\mysql-%ver_mysql80%-x64.zip" (
    echo. && echo ^> Extracting mysql v%ver_mysql80% x64 ...
    if exist "%ODIR%\mysql-8.0-x64" RD /S /Q "%ODIR%\mysql-8.0-x64"
    %UNZIP% x "%TMPDIR%\mysql-%ver_mysql80%-x64.zip" -o"%ODIR%" -y > nul
    ren "%ODIR%\mysql-%ver_mysql80%-winx64" mysql-8.0-x64
    copy /Y "%STUB%\mysql8.ini" "%ODIR%\mysql-8.0-x64\my.ini" > nul
	RD /S /Q "%ODIR%\mysql-8.0-x64\etc"
	RD /S /Q "%ODIR%\mysql-8.0-x64\include"
    RD /S /Q "%ODIR%\mysql-8.0-x64\lib\plugin\debug"
    RD /S /Q "%ODIR%\mysql-8.0-x64\run"
    RD /S /Q "%ODIR%\mysql-8.0-x64\var"
)

:: Cleanup residual files ------------------------------------------------------------------------------------------------
echo. && echo Cleanup residual files ...
forfiles /p "%ODIR%" /s /m *.pdb /d -1 /c "cmd /c del /F @file"
forfiles /p "%ODIR%\mysql-5.6-x64\lib" /s /m *.lib /d -1 /c "cmd /c del /F @file"
forfiles /p "%ODIR%\mysql-5.6-x86\lib" /s /m *.lib /d -1 /c "cmd /c del /F @file"
forfiles /p "%ODIR%\mysql-5.7-x64\lib" /s /m *.lib /d -1 /c "cmd /c del /F @file"
forfiles /p "%ODIR%\mysql-5.7-x86\lib" /s /m *.lib /d -1 /c "cmd /c del /F @file"
forfiles /p "%ODIR%\mysql-8.0-x64\lib" /s /m *.lib /d -1 /c "cmd /c del /F @file"
echo All files already downloaded! && echo.
