; by Aris Ripandi - 2019

#define BasePath      "..\..\"

#define AppPublisher  "Aris Ripandi"
#define AppWebsite    "https://varlet.dev"
#define AppGithubUrl  "https://github.com/riipandi/varlet-addons"

[Setup]
AppPublisher               = {#AppPublisher}
AppPublisherURL            = {#AppWebsite}
AppSupportURL              = {#AppWebsite}
AppUpdatesURL              = {#AppWebsite}
AppCopyright               = Copyright (c) {#AppPublisher}
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
SetupIconFile              = "{#BasePath}include\setup-icon.ico"
WizardImageFile            = "{#BasePath}include\setup-img-side.bmp"
WizardSmallImageFile       = "{#BasePath}include\setup-img-top.bmp"
LicenseFile                = "{#BasePath}license.txt"
OutputDir                  = {#BasePath}_output
UninstallFilesDir          = {app}
Uninstallable              = yes
CreateUninstallRegKey      = yes
DirExistsWarning           = yes
AlwaysRestart              = no
