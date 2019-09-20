; by Aris Ripandi - 2019

#define BasePath      "..\"

#define AppVersion    "10.4.8"
#define AppName       "Varlet MariaDB"
#define AppPublisher  "Aris Ripandi"
#define AppWebsite    "https://arisio.us"
#define AppGithubUrl  "https://github.com/riipandi/varlet-mariadb"
#define SetupFileName "varlet-mariadb-10.4.8-x64"

#define DBRootPassword  "secret"
#define DBServiceName   "VarletMariaDB"
#define DBServicePort   "3306"

[Setup]
AppName                    = {#AppName}
AppVersion                 = {#AppVersion}
AppPublisher               = {#AppPublisher}
AppPublisherURL            = {#AppWebsite}
AppSupportURL              = {#AppWebsite}
AppUpdatesURL              = {#AppWebsite}
DefaultGroupName           = {#AppName}
OutputBaseFilename         = {#SetupFileName}
AppCopyright               = Copyright (c) {#AppPublisher}
ArchitecturesAllowed            = x64
ArchitecturesInstallIn64BitMode = x64
Compression                = lzma2/max
SolidCompression           = yes
DisableStartupPrompt       = yes
DisableWelcomePage         = no
DisableDirPage             = no
DisableProgramGroupPage    = yes
DisableReadyPage           = no
DisableFinishedPage        = no
AppendDefaultDirName       = yes
AlwaysShowComponentsList   = no
FlatComponentsList         = yes

SetupIconFile         = "setup-icon.ico"
LicenseFile           = "varlet-license.txt"
WizardImageFile       = "setup-img-side.bmp"
WizardSmallImageFile  = "setup-img-top.bmp"
DefaultDirName        = {sd}\Varlet\mariadb
UninstallFilesDir     = {app}
Uninstallable         = yes
CreateUninstallRegKey = yes
DirExistsWarning      = yes
AlwaysRestart         = no
OutputDir             = {#BasePath}output

[Registry]
Root: HKLM; Subkey: "Software\{#AppPublisher}"; Flags: uninsdeletekeyifempty;
Root: HKLM; Subkey: "Software\{#AppPublisher}\{#AppName}"; Flags: uninsdeletekey;
Root: HKLM; Subkey: "Software\{#AppPublisher}\{#AppName}"; ValueType: string; ValueName: "InstallPath"; ValueData: "{app}";
Root: HKLM; Subkey: "Software\{#AppPublisher}\{#AppName}"; ValueType: string; ValueName: "AppVersion"; ValueData: "{#AppVersion}";

[Tasks]
Name: task_add_path_envars; Description: "Add PATH environment variables";
Name: task_install_vcredis; Description: "Install Visual C++ Redistributable"; Flags: unchecked;

[Files]
; Main project files ----------------------------------------------------------------------------------
Source: varlet-license.txt; DestDir: {app}; Flags: ignoreversion
Source: {#BasePath}packages\mariadb\*; DestDir: {app}; Flags: ignoreversion recursesubdirs
; Dependencies and libraries -------------------------------------------------------------------------
Source: {#BasePath}packages\vcredis\vcredis2012x64.exe; DestDir: {tmp}; Flags: ignoreversion deleteafterinstall
Source: {#BasePath}packages\vcredis\vcredis1519x64.exe; DestDir: {tmp}; Flags: ignoreversion deleteafterinstall

[Run]
; Install external packages --------------------------------------------------------------------------
Filename: "msiexec.exe"; Parameters: "/i ""{tmp}\vcredis2012x64.exe"" /quiet /norestart"; Flags: waituntilterminated; Tasks: task_install_vcredis
Filename: "msiexec.exe"; Parameters: "/i ""{tmp}\vcredis1519x64.exe"" /quiet /norestart"; Flags: waituntilterminated; Tasks: task_install_vcredis

; ----------------------------------------------------------------------------------------------------
; Programmatic section -------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------------------
#include 'setup-helpers.iss'

[Code]
var
  DataDir: String;
  DBParameterPage: TInputQueryWizardPage;

function InitializeSetup(): Boolean;
begin
  RegQueryStringValue(HKLM, 'Software\{#AppPublisher}\{#AppName}', 'InstallPath', InstallPath);
  if InstallPath <> '' then begin
    MsgBox('{#AppName} already installed.'#10'You have to uninstall older version first.'#10#10'Installation process aborted!.', mbInformation, MB_OK);
    Result := False;
  end else if IsServiceRunning('{#DBServiceName}') then begin
    MsgBox('Current service already running.'#10'Stop it first!.', mbInformation, MB_OK);
    Result := False;
  end else begin
    Result := True;
  end
end;

procedure InitializeWizard();
begin
  CustomLicensePage;
  CreateFooterText('{#AppGithubUrl}');
  DBParameterPage := CreateInputQueryPage(wpSelectDir,'Database Configuration', 'Adjust the following parameters!', '');
  DBParameterPage.Add('Database Port:', False);
  DBParameterPage.Values[0] := '{#DBServicePort}';
  DBParameterPage.Edits[0].Width := 80;
end;

procedure RegisterPreviousData(PreviousDataKey: Integer);
begin
  SetPreviousData(PreviousDataKey, 'Database Port', DBParameterPage.Values[0]);
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  if CurPageID = DBParameterPage.ID then begin
    if DBParameterPage.Values[0] = '' then begin
      MsgBox('Database port must be filled!', mbError, MB_OK);
      Result := False;
    end else begin
      Result := True;
    end;
  end else
    Result := True;
end;

function GetDataDir(S: String): String;
begin
  if DataDir = '' then
    DataDir := ExpandConstant('{app}') + '\data';
  Result := DataDir;
end;

function CheckDataDir: Boolean;
begin
  Result := Pos('Data', WizardSelectedComponents(true)) > 0;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = DBParameterPage.ID then begin
    WizardForm.NextButton.Caption := SetupMessage(msgButtonInstall)
  end;
end;

procedure InstallApplicationService;
var
  InitDBParameter : String;
  ServiceParameter : String;
begin
  InitDBParameter := '--datadir="'+ExpandConstant('{app}\data')+'" --port="'+DBParameterPage.Values[0]+'" --password="'+ExpandConstant('{#DBRootPassword}')+'"';
  ServiceParameter := '--install-manual "'+ExpandConstant('{#DBServiceName}')+'" --defaults-file="'+ExpandConstant('{app}\my.ini')+'"';
  if Exec(ExpandConstant('{app}\bin\mysql_install_db.exe'), InitDBParameter, '', SW_HIDE, ewWaitUntilTerminated, ResultCode) then begin
    if not Exec(ExpandConstant('{app}\bin\mysqld.exe'), ServiceParameter, '', SW_HIDE, ewWaitUntilTerminated, ResultCode) then begin
      MsgBox('Failed to creating {#DBServiceName} service!', mbInformation, MB_OK);
    end else if not Exec(ExpandConstant('net.exe'), 'start {#DBServiceName}', '', SW_HIDE, ewWaitUntilTerminated, ResultCode) then begin
      MsgBox('Failed starting {#DBServiceName} service!', mbInformation, MB_OK);
    end;
  end else begin
    MsgBox('Failed to initializing database at '+ DataDir, mbInformation, MB_OK);
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then begin
    WizardForm.StatusLabel.Caption := 'Configuring application...';
    FileReplaceString(ExpandConstant('{app}\my.ini'), '<<INSTALL_DIR>>', PathWithSlashes(ExpandConstant('{app}')));
    FileReplaceString(ExpandConstant('{app}\my.ini'), '<<SERVICE_NAME>>', ExpandConstant('{#DBServiceName}'));
    FileReplaceString(ExpandConstant('{app}\my.ini'), '<<SERVICE_PORT>>', DBParameterPage.Values[0]);

    WizardForm.StatusLabel.Caption := 'Installing application services...';
    InstallApplicationService;

    WizardForm.StatusLabel.Caption := 'Creating firewall exception...';
    FirewallAdd('{#AppName}', DBParameterPage.Values[0]);

    if WizardIsTaskSelected('task_add_path_envars') then begin
      WizardForm.StatusLabel.Caption := 'Adding installation dir to PATH...';
      EnvAddPath(ExpandConstant('{app}') +'\bin');
    end;
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  case CurUninstallStep of
    usUninstall:
      begin
        KillService('{#DBServiceName}');
        EnvRemovePath(ExpandConstant('{app}') +'\bin');
      end;
    usPostUninstall:
      begin
        FirewallDelete('{#AppName}');
      end;
  end;
end;
