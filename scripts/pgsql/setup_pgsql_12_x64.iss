; by Aris Ripandi - 2019

#include '..\..\include\setup-header.iss'

#define AppVersion      GetFileVersion('..\..\_dstdir\pgsql-12-x64\bin\psql.exe')
#define AppName         "Varlet PostgreSQL 12"
#define DBServiceName   "VarletPgSQL12"
#define DBRootPassword  "secret"
#define DBServicePort   "5432"
#define DBDataDirectory "{commonappdata}\Varlet\PostgreSQL-12"

[Setup]
AppName                         = {#AppName}
AppVersion                      = {#AppVersion}
DefaultGroupName                = {#AppName}
OutputBaseFilename              = "varlet-pgsql-{#AppVersion}-x64"
DefaultDirName                  = {code:GetDefaultDir}
ArchitecturesAllowed            = x64
ArchitecturesInstallIn64BitMode = x64

[Registry]
Root: HKLM; Subkey: "Software\{#AppPublisher}"; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "Software\{#AppPublisher}\{#AppName}"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\{#AppPublisher}\{#AppName}"; ValueType: string; ValueName: "InstallPath"; ValueData: "{app}"
Root: HKLM; Subkey: "Software\{#AppPublisher}\{#AppName}"; ValueType: string; ValueName: "AppVersion"; ValueData: "{#AppVersion}"

[Tasks]
Name: task_add_path_envars; Description: "Add PATH environment variables"
Name: task_autorun_service; Description: "Run services when Windows starts"

[Files]
Source: {#BasePath}_tmpdir\vcredis\vcredis2010x64.exe; DestDir: {tmp}; Flags: ignoreversion deleteafterinstall
Source: {#BasePath}_tmpdir\vcredis\vcredis2012x64.exe; DestDir: {tmp}; Flags: ignoreversion deleteafterinstall
Source: {#BasePath}_tmpdir\vcredis\vcredis1519x64.exe; DestDir: {tmp}; Flags: ignoreversion deleteafterinstall
Source: "{#BasePath}_dstdir\pgsql-12-x64\*"; DestDir: {app}; Flags: ignoreversion recursesubdirs

[Run]
Filename: "{tmp}\vcredis2010x64.exe"; Parameters: "/install /quiet /norestart"; Description: "Installing VCRedist 2010"; Flags: waituntilterminated; Check: VCRedist2010NotInstalled
Filename: "{tmp}\vcredis2012x64.exe"; Parameters: "/install /quiet /norestart"; Description: "Installing VCRedist 2012"; Flags: waituntilterminated; Check: VCRedist2012NotInstalled
Filename: "{tmp}\vcredis1519x64.exe"; Parameters: "/install /quiet /norestart"; Description: "Installing VCRedist 2015"; Flags: waituntilterminated; Check: VCRedist2015NotInstalled

[Dirs]
Name: "{#DBDataDirectory}"; Permissions: users-full;

[UninstallDelete]
Type: filesandordirs; Name: "{#DBDataDirectory}"

; ----------------------------------------------------------------------------------------------------------------------
; Programmatic section -------------------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------------------------------------

#include '..\..\include\setup-helpers.iss'

[Code]
const AppRegKey = 'Software\{#AppPublisher}\{#AppName}';
const AppFolder = '\Varlet\PostgreSQL-12';
var
  DBParameterPage: TInputQueryWizardPage;
  BinDir : String;
  DataDir : String;
  PassFile : String;
  Parameter : String;
  SvcName : String;

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

function GetServiceParameter(Param: String): String;
begin
  if Param = 'Port' then
    Result := DBParameterPage.Values[0]
  else if Param = 'Password' then
    Result := DBParameterPage.Values[1];
end;

procedure InstallApplicationService;
begin
  BinDir   := ExpandConstant('{app}\bin');
  DataDir  := ExpandConstant('{#DBDataDirectory}\data');
  SvcName  := ExpandConstant('#DBServiceName');
  PassFile := ExpandConstant('{tmp}\pgpass.txt');

  // Initialize database
  WizardForm.StatusLabel.Caption := 'Initialize database ...';
  SaveStringToFile(PassFile, GetServiceParameter('Password'), True);
  Parameter := '-D "'+DataDir+'" -U postgres -A password -E utf8 --pwfile="'+PassFile+'"';
  Exec(BinDir + '\initdb.exe', Parameter, '', SW_HIDE, ewWaitUntilTerminated, ResultCode)

  // Edit configuration
  DeleteFile(DataDir + '\pg_hba.conf');
  if IsAppRunning('mysqld.exe') then TaskKillByPid('pg_ctl.exe');
  WizardForm.StatusLabel.Caption := 'Configuring application service ...';
  FileReplaceString(DataDir + '\postgresql.conf', '#listen_addresses = ''localhost''', 'listen_addresses = ''*''');
  FileReplaceString(DataDir + '\postgresql.conf', '#port = 5432', 'port = ' + GetServiceParameter('Port'));
  SaveStringToFile(DataDir + '\pg_hba.conf', 'host  all  all  0.0.0.0/0  password', True);
  SaveStringToFile(DataDir + '\pg_hba.conf', #13#10 + 'host  all  all  ::1/128    password', True);
  SaveStringToFile(DataDir + '\pg_hba.conf', #13#10 + 'host  all  all  ::1/0      password', True);

  // Install services
  WizardForm.StatusLabel.Caption := 'Registering application service ...';
  Exec(BinDir + '\pg_ctl.exe', 'register -N {#DBServiceName} -D "' + DataDir + '" -S demand', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Exec(ExpandConstant('net.exe'), 'start {#DBServiceName}', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  DeleteFile(PassFile);
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
    InstallApplicationService;
    if WizardIsTaskSelected('task_autorun_service') then begin
      Exec(ExpandConstant('sc.exe'), 'config {#DBServiceName} start=auto', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    end else begin
      Exec(ExpandConstant('sc.exe'), 'config {#DBServiceName} start=demand', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    end;

    WizardForm.StatusLabel.Caption := 'Creating firewall exception...';
    FirewallAdd('{#DBServiceName}', GetServiceParameter('Port'));

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
