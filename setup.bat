@echo off

set PWD=%~dp0

:: MariaDB
echo. && call "%PWD%\scripts\mariadb\get_packages.bat"
"%programfiles(x86)%\Inno Setup 6\ISCC.exe" /Qp "%PWD%\scripts\mariadb\setup_mariadb_10.3_x64.iss"
"%programfiles(x86)%\Inno Setup 6\ISCC.exe" /Qp "%PWD%\scripts\mariadb\setup_mariadb_10.3_x86.iss"

"%programfiles(x86)%\Inno Setup 6\ISCC.exe" /Qp "%PWD%\scripts\mariadb\setup_mariadb_10.4_x64.iss"
"%programfiles(x86)%\Inno Setup 6\ISCC.exe" /Qp "%PWD%\scripts\mariadb\setup_mariadb_10.4_x86.iss"

:: MySQL
echo. && call "%PWD%\scripts\mysql\get_packages.bat"
"%programfiles(x86)%\Inno Setup 6\ISCC.exe" /Qp "%PWD%\scripts\mysql\setup_mysql_5.6_x64.iss"
"%programfiles(x86)%\Inno Setup 6\ISCC.exe" /Qp "%PWD%\scripts\mysql\setup_mysql_5.6_x86.iss"

"%programfiles(x86)%\Inno Setup 6\ISCC.exe" /Qp "%PWD%\scripts\mysql\setup_mysql_5.7_x64.iss"
"%programfiles(x86)%\Inno Setup 6\ISCC.exe" /Qp "%PWD%\scripts\mysql\setup_mysql_5.7_x86.iss"

"%programfiles(x86)%\Inno Setup 6\ISCC.exe" /Qp "%PWD%\scripts\mysql\setup_mysql_8.0_x64.iss"

:: MySQL
echo. && call "%PWD%\scripts\pgsql\get_packages.bat"
"%programfiles(x86)%\Inno Setup 6\ISCC.exe" /Qp "%PWD%\scripts\pgsql\setup_pgsql_9.6_x64.iss"
"%programfiles(x86)%\Inno Setup 6\ISCC.exe" /Qp "%PWD%\scripts\pgsql\setup_pgsql_9.6_x86.iss"

"%programfiles(x86)%\Inno Setup 6\ISCC.exe" /Qp "%PWD%\scripts\pgsql\setup_pgsql_10_x64.iss"
"%programfiles(x86)%\Inno Setup 6\ISCC.exe" /Qp "%PWD%\scripts\pgsql\setup_pgsql_10_x86.iss"

"%programfiles(x86)%\Inno Setup 6\ISCC.exe" /Qp "%PWD%\scripts\pgsql\setup_pgsql_11_x64.iss"
"%programfiles(x86)%\Inno Setup 6\ISCC.exe" /Qp "%PWD%\scripts\pgsql\setup_pgsql_12_x86.iss"

echo. && pause && echo.
