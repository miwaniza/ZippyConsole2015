; Script generated with the Venis Install Wizard

; Define your application name
!define APPNAME "ZippyConsole"
!define APPNAMEANDVERSION "ZippyConsole 1.0"

; Main Install settings
Name "${APPNAMEANDVERSION}"
InstallDir "$PROFILE\Documents\WindowsPowerShell\Modules\ZippyConsole"
InstallDirRegKey HKLM "Software\${APPNAME}" ""
OutFile "..\ZippyConsole.exe"

; Modern interface settings
!include "MUI.nsh"

!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_RUN "$INSTDIR\ZippyConsole.lnk"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "ZippyConsole EULA.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Set languages (first is default language)
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_RESERVEFILE_LANGDLL

Section "ZippyConsole" Section1

	; Set Section properties
	SetOverwrite on

	; Set Section Files and Shortcuts
	SetOutPath "$INSTDIR\"
	File "Autodesk Vault 2015 SDK EULA.rtf"
	File "ZippyConsole EULA.txt"
	File "ZippyConsole.ico"
	File "ZippyConsole.lnk"
;	File "ZippyConsole.nsi"
	File "ZippyConsole.psd1"
	File "ZippyConsole.psm1"
	SetOutPath "$INSTDIR\bin\"
	FILE "bin\Autodesk.Connectivity.Explorer.Extensibility.dll"
	FILE "bin\Autodesk.Connectivity.Explorer.Extensibility.xml"
	FILE "bin\Autodesk.Connectivity.Explorer.ExtensibilityTools.dll"
	FILE "bin\Autodesk.Connectivity.Explorer.ExtensibilityTools.xml"
	FILE "bin\Autodesk.Connectivity.Extensibility.Framework.dll"
	FILE "bin\Autodesk.Connectivity.Extensibility.Framework.xml"
	FILE "bin\Autodesk.Connectivity.JobProcessor.Extensibility.dll"
	FILE "bin\Autodesk.Connectivity.JobProcessor.Extensibility.xml"
	FILE "bin\Autodesk.Connectivity.WebServices.dll"
	FILE "bin\Autodesk.Connectivity.WebServices.xml"
	FILE "bin\Autodesk.DataManagement.Client.Framework.dll"
	FILE "bin\Autodesk.DataManagement.Client.Framework.xml"
	FILE "bin\Autodesk.DataManagement.Client.Framework.Forms.dll"
	FILE "bin\Autodesk.DataManagement.Client.Framework.Forms.xml"
	FILE "bin\Autodesk.DataManagement.Client.Framework.Vault.dll"
	FILE "bin\Autodesk.DataManagement.Client.Framework.Vault.xml"
	FILE "bin\Autodesk.DataManagement.Client.Framework.Vault.Forms.dll"
	FILE "bin\Autodesk.DataManagement.Client.Framework.Vault.Forms.xml"
	FILE "bin\DevExpress.Data.v13.1.dll"
	FILE "bin\DevExpress.Printing.v13.1.Core.dll"
	FILE "bin\DevExpress.Utils.v13.1.dll"
	FILE "bin\DevExpress.XtraBars.v13.1.dll"
	FILE "bin\DevExpress.XtraEditors.v13.1.dll"
	FILE "bin\DevExpress.XtraGrid.v13.1.dll"
	FILE "bin\DevExpress.XtraLayout.v13.1.dll"
	FILE "bin\DevExpress.XtraPrinting.v13.1.dll"
	FILE "bin\DevExpress.XtraTreeList.v13.1.dll"
	CreateShortCut "$DESKTOP\ZippyConsole.lnk" "$INSTDIR\ZippyConsole.lnk"
	CreateDirectory "$SMPROGRAMS\ZippyBytes\ZippyConsole"
	CreateShortCut "$SMPROGRAMS\ZippyBytes\ZippyConsole\ZippyConsole.lnk" "$INSTDIR\ZippyConsole.lnk"
	CreateShortCut "$SMPROGRAMS\ZippyBytes\ZippyConsole\Uninstall.lnk" "$INSTDIR\uninstall.exe"

SectionEnd

Section -FinishSection

	WriteRegStr HKLM "Software\${APPNAME}" "" "$INSTDIR"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$INSTDIR\uninstall.exe"
	WriteUninstaller "$INSTDIR\uninstall.exe"

SectionEnd

; Modern install component descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${Section1} ""
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;Uninstall section
Section Uninstall

	;Remove from registry...
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
	DeleteRegKey HKLM "SOFTWARE\${APPNAME}"

	; Delete self
	Delete "$INSTDIR\uninstall.exe"

	; Delete Shortcuts
	Delete "$DESKTOP\ZippyConsole.lnk"
	Delete "$SMPROGRAMS\ZippyBytes\ZippyConsole\ZippyConsole.lnk"
	Delete "$SMPROGRAMS\ZippyBytes\ZippyConsole\Uninstall.lnk"

	; Clean up ZippyConsole
	Delete "$INSTDIR\Autodesk Vault 2015 SDK EULA.rtf"
	Delete "$INSTDIR\ZippyConsole EULA.txt"
	Delete "$INSTDIR\ZippyConsole.ico"
	Delete "$INSTDIR\ZippyConsole.lnk"
	Delete "$INSTDIR\ZippyConsole.nsi"
	Delete "$INSTDIR\ZippyConsole.psd1"
	Delete "$INSTDIR\ZippyConsole.psm1"
	Delete "Autodesk.Connectivity.Explorer.Extensibility.dll"
	Delete "Autodesk.Connectivity.Explorer.Extensibility.xml"
	Delete "Autodesk.Connectivity.Explorer.ExtensibilityTools.dll"
	Delete "Autodesk.Connectivity.Explorer.ExtensibilityTools.xml"
	Delete "Autodesk.Connectivity.Extensibility.Framework.dll"
	Delete "Autodesk.Connectivity.Extensibility.Framework.xml"
	Delete "Autodesk.Connectivity.JobProcessor.Extensibility.dll"
	Delete "Autodesk.Connectivity.JobProcessor.Extensibility.xml"
	Delete "Autodesk.Connectivity.WebServices.dll"
	Delete "Autodesk.Connectivity.WebServices.xml"
	Delete "Autodesk.DataManagement.Client.Framework.dll"
	Delete "Autodesk.DataManagement.Client.Framework.xml"
	Delete "Autodesk.DataManagement.Client.Framework.Forms.dll"
	Delete "Autodesk.DataManagement.Client.Framework.Forms.xml"
	Delete "Autodesk.DataManagement.Client.Framework.Vault.dll"
	Delete "Autodesk.DataManagement.Client.Framework.Vault.xml"
	Delete "Autodesk.DataManagement.Client.Framework.Vault.Forms.dll"
	Delete "Autodesk.DataManagement.Client.Framework.Vault.Forms.xml"
	Delete "DevExpress.Data.v13.1.dll"
	Delete "DevExpress.Printing.v13.1.Core.dll"
	Delete "DevExpress.Utils.v13.1.dll"
	Delete "DevExpress.XtraBars.v13.1.dll"
	Delete "DevExpress.XtraEditors.v13.1.dll"
	Delete "DevExpress.XtraGrid.v13.1.dll"
	Delete "DevExpress.XtraLayout.v13.1.dll"
	Delete "DevExpress.XtraPrinting.v13.1.dll"
	Delete "DevExpress.XtraTreeList.v13.1.dll"

	; Remove remaining directories
	RMDir "$SMPROGRAMS\ZippyBytes\ZippyConsole"
	RMDir "$INSTDIR\bin\"
	RMDir "$INSTDIR\"

SectionEnd

; eof