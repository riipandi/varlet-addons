@echo off
setlocal

set ROOT=%~dp0..
set CURL=%ROOT%\utils\curl.exe
set UNZIP=%ROOT%\utils\7za.exe
set TMPDIR=%ROOT%\_tmpdir
set DSTDIR=%ROOT%\_dstdir
set STUB=%ROOT%\stubs

:: ---------------------------------------------------------------------------------------------------------------------

if not exist "%TMPDIR%\vcredis\" (
  echo. && echo ^> Downloading Visual C++ Redistributable ...
  if not exist "%TMPDIR%\vcredis" mkdir "%TMPDIR%\vcredis" 2> NUL
  %CURL% -L# "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" -o "%TMPDIR%\vcredis\vcredis2012x86.exe"
  %CURL% -L# "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe" -o "%TMPDIR%\vcredis\vcredis2012x64.exe"
  %CURL% -L# "https://aka.ms/vs/16/release/VC_redist.x86.exe" -o "%TMPDIR%\vcredis\vcredis1519x86.exe"
  %CURL% -L# "https://aka.ms/vs/16/release/VC_redist.x64.exe" -o "%TMPDIR%\vcredis\vcredis1519x64.exe"
)

pause
