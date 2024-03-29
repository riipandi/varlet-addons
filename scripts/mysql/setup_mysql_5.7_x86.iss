; by Aris Ripandi - 2019

#include '..\..\include\setup-header.iss'

#define AppVersion      GetFileVersion('..\..\_dstdir\mysql-5.7-x86\bin\mysql.exe')
#define AppName         "Varlet MySQL 5.7"
#define DBServiceName   "VarletMySQL57"
#define DBRootPassword  "secret"
#define DBServicePort   "3306"
#define DBDataDirectory "{commonappdata}\Varlet\MySQL-5.7"

[Setup]
AppName                         = {#AppName}
AppVersion                      = {#AppVersion}
DefaultGroupName                = {#AppName}
OutputBaseFilename              = "varlet-mysql-{#AppVersion}-x86"
DefaultDirName                  = {code:GetDefaultDir}
ArchitecturesAllowed            = x86

[Registry]
Root: HKLM; Subkey: "Software\{#AppPublisher}"; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "Software\{#AppPublisher}\{#AppName}"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\{#AppPublisher}\{#AppName}"; ValueType: string; ValueName: "InstallPath"; ValueData: "{app}"
Root: HKLM; Subkey: "Software\{#AppPublisher}\{#AppName}"; ValueType: string; ValueName: "AppVersion"; ValueData: "{#AppVersion}"

[Tasks]
Name: task_add_path_envars; Description: "Add PATH environment variables"
Name: task_autorun_service; Description: "Run services when Windows starts"

[Files]
Source: {#BasePath}_tmpdir\vcredis\vcredis2010x86.exe; DestDir: {tmp}; Flags: ignoreversion deleteafterinstall
Source: {#BasePath}_tmpdir\vcredis\vcredis2012x86.exe; DestDir: {tmp}; Flags: ignoreversion deleteafterinstall
Source: {#BasePath}_tmpdir\vcredis\vcredis1519x86.exe; DestDir: {tmp}; Flags: ignoreversion deleteafterinstall
Source: "{#BasePath}_dstdir\mysql-5.7-x86\*"; DestDir: {app}; Flags: ignoreversion recursesubdirs
Source: "{#BasePath}stubs\mysql5.ini"; DestDir: {app}; DestName: "my.ini"; Flags: ignoreversion

[Run]
Filename: "{tmp}\vcredis2010x86.exe"; Parameters: "/install /quiet /norestart"; Description: "Installing VCRedist 2010"; Flags: waituntilterminated; Check: VCRedist2010NotInstalled
Filename: "{tmp}\vcredis2012x86.exe"; Parameters: "/install /quiet /norestart"; Description: "Installing VCRedist 2012"; Flags: waituntilterminated; Check: VCRedist2012NotInstalled
Filename: "{tmp}\vcredis1519x86.exe"; Parameters: "/install /quiet /norestart"; Description: "Installing VCRedist 2015"; Flags: waituntilterminated; Check: VCRedist2015NotInstalled

[Dirs]
Name: "{#DBDataDirectory}"; Permissions: users-full;
Name: "{#DBDataDirectory}\uploads"; Permissions: users-full;

[UninstallDelete]
Type: filesandordirs; Name: "{#DBDataDirectory}"

; ----------------------------------------------------------------------------------------------------------------------
; Programmatic section -------------------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------------------------------------

#include '..\..\include\setup-helpers.iss'

[Code]
const AppRegKey = 'Software\{#AppPublisher}\{#AppName}';
const AppFolder = '\Varlet\MySQL-5.7';
var DBParameterPage: TInputQueryWizardPage;

function GetDefaultDir(Param: string): string;
begin
  Result := GetAppRegistry('InstallPath');
  if not RegKeyExists(HKLM, AppRegKey) then
    Result := ExpandConstant('{commonpf}') + AppFolder;
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := (PageID = wpSelectDir) and DirExists(GetAppRegistry('InstallPath'));
  if not RegKeyExists(HKLM, AppRegKey) then
    Result := (PageID = wpSelectDir) and DirExists(ExpandConstant('{commonpf}') + AppFolder);
end;

function InitializeSetup: Boolean;
begin
  Result := True;
  if RegKeyExists(HKLM, AppRegKey) then begin
    InstallPath := GetAppRegistry('InstallPath');
    Str := 'Previous installation detected at: '+InstallPath+''#13#13'This process will update current installation.'#13#13'Please backup your databases first.'#13#13'Do you want to start the process?';
    Result := MsgBox(Str, mbConfirmation, MB_YESNO) = idYes;
    if Result = False then begin
      MsgBox('Installation cancelled!', mbInformation, MB_OK);
      Abort;
    end else begin
      if IsServiceRunning('{#DBServiceName}') then KillService('{#DBServiceName}');
      if IsAppRunning('mysqld.exe') then TaskKillByPid('mysqld.exe');
      if IsAppRunning('mysql.exe') then TaskKillByPid('mysql.exe');
    end;
  end;
end;

procedure InitializeWizard();
begin
  CustomLicensePage;
  CreateFooterText('varlet.dev');
  DBParameterPage := CreateInputQueryPage(wpSelectDir,'Database Configuration', 'Adjust the following parameters!', '');

  DBParameterPage.Add('Database Port:', False);
  DBParameterPage.Values[0] := '{#DBServicePort}';
  DBParameterPage.Edits[0].Width := 80;

  DBParameterPage.Add('Root Password:', True);
  DBParameterPage.Values[1] := '{#DBRootPassword}';
  DBParameterPage.Edits[1].Width := 140;
end;

procedure RegisterPreviousData(PreviousDataKey: Integer);
begin
  SetPreviousData(PreviousDataKey, 'Database Port', DBParameterPage.Values[0]);
  SetPreviousData(PreviousDataKey, 'Root Password', DBParameterPage.Values[1]);
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  if CurPageID = DBParameterPage.ID then begin
    if DBParameterPage.Values[0] = '' then begin
      MsgBox('Database port must be filled!', mbError, MB_OK);
      Result := False;
    end else if DBParameterPage.Values[1] = '' then begin
      MsgBox('Root password must be filled!', mbError, MB_OK);
      Result := False;
    end else begin
      Result := True;
    end;
  end else
    Result := True;
end;

procedure InitializeData;
var InitDBParameter : String;
begin
  WizardForm.StatusLabel.Caption := 'Initializing database...';
  InitDBParameter := '--defaults-file="'+ExpandConstant('{app}\my.ini')+'" --initialize-insecure';
  Exec(ExpandConstant('{app}\bin\mysqld.exe'), InitDBParameter, '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
end;

procedure InstallApplicationService;
var ServiceParameter : String;
begin
  WizardForm.StatusLabel.Caption := 'Installing application services...';
  ServiceParameter := '--install-manual "'+ExpandConstant('{#DBServiceName}')+'" --defaults-file="'+ExpandConstant('{app}\my.ini')+'"';
  if not Exec(ExpandConstant('{app}\bin\mysqld.exe'), ServiceParameter, '', SW_HIDE, ewWaitUntilTerminated, ResultCode) then begin
    MsgBox('Failed to creating {#DBServiceName} service!', mbInformation, MB_OK);
  end else if not Exec(ExpandConstant('net.exe'), 'start {#DBServiceName}', '', SW_HIDE, ewWaitUntilTerminated, ResultCode) then begin
    MsgBox('Failed starting {#DBServiceName} service!', mbInformation, MB_OK);
  end;

  if WizardIsTaskSelected('task_autorun_service') then begin
    Exec(ExpandConstant('sc.exe'), 'config {#DBServiceName} start=auto', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  end else begin
    Exec(ExpandConstant('sc.exe'), 'config {#DBServiceName} start=demand', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  end;
end;

procedure ConfigureDatabaseRootPassword;
var Parameter: String;
begin
  WizardForm.StatusLabel.Caption := 'Resetting database root password...';

  Parameter := '-uroot -e "ALTER USER ''root''@''localhost'' IDENTIFIED BY '''+DBParameterPage.Values[1]+''';"';
  Exec(ExpandConstant('{app}\bin\mysql.exe'), Parameter, '', SW_HIDE, ewWaitUntilTerminated, ResultCode);

  Parameter := '-uroot -p'''+DBParameterPage.Values[1]+''' -e "ALTER USER ''root''@''127.0.0.1'' IDENTIFIED BY '''+DBParameterPage.Values[1]+''';"';
  Exec(ExpandConstant('{app}\bin\mysql.exe'), Parameter, '', SW_HIDE, ewWaitUntilTerminated, ResultCode);

  Parameter := '-uroot -p'''+DBParameterPage.Values[1]+''' -e "FLUSH PRIVILEGES";';
  Exec(ExpandConstant('{app}\bin\mysql.exe'), Parameter, '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpLicense then begin
    WizardForm.NextButton.Caption := '&I agree';
  end;
  if CurPageID = DBParameterPage.ID then begin
    WizardForm.NextButton.Caption := SetupMessage(msgButtonInstall)
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then begin
    WizardForm.StatusLabel.Caption := 'Configuring application...';
    FileReplaceString(ExpandConstant('{app}\my.ini'), '<<DATA_DIR>>', PathWithSlashes(ExpandConstant('{#DBDataDirectory}')));
    FileReplaceString(ExpandConstant('{app}\my.ini'), '<<INSTALL_DIR>>', PathWithSlashes(ExpandConstant('{app}')));
    FileReplaceString(ExpandConstant('{app}\my.ini'), '<<SERVICE_NAME>>', ExpandConstant('{#DBServiceName}'));
    FileReplaceString(ExpandConstant('{app}\my.ini'), '<<SERVICE_PORT>>', DBParameterPage.Values[0]);

    InitializeData;
    InstallApplicationService;
    ConfigureDatabaseRootPassword;

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
