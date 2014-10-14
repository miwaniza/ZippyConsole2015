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
	File "Autodesk Vault 2014 SDK EULA.rtf"
	File "ZippyConsole EULA.txt"
	File "ZippyConsole.ico"
	File "ZippyConsole.lnk"
	File "ZippyConsole.nsi"
	File "ZippyConsole.psd1"
	File "ZippyConsole.psm1"
	SetOutPath "$INSTDIR\bin\"
	File "bin\Autodesk.Connectivity.Explorer.Extensibility.dll"
	File "bin\Autodesk.Connectivity.Explorer.Extensibility.xml"
	File "bin\Autodesk.Connectivity.Explorer.ExtensibilityTools.dll"
	File "bin\Autodesk.Connectivity.Explorer.ExtensibilityTools.xml"
	File "bin\Autodesk.Connectivity.Extensibility.Framework.dll"
	File "bin\Autodesk.Connectivity.Extensibility.Framework.xml"
	File "bin\Autodesk.Connectivity.JobProcessor.Extensibility.dll"
	File "bin\Autodesk.Connectivity.JobProcessor.Extensibility.xml"
	File "bin\Autodesk.Connectivity.WebServices.dll"
	File "bin\Autodesk.Connectivity.WebServices.xml"
	File "bin\Autodesk.DataManagement.Client.Framework.dll"
	File "bin\Autodesk.DataManagement.Client.Framework.Forms.dll"
	File "bin\Autodesk.DataManagement.Client.Framework.Forms.xml"
	File "bin\Autodesk.DataManagement.Client.Framework.Vault.dll"
	File "bin\Autodesk.DataManagement.Client.Framework.Vault.Forms.dll"
	File "bin\Autodesk.DataManagement.Client.Framework.Vault.Forms.xml"
	File "bin\Autodesk.DataManagement.Client.Framework.Vault.xml"
	File "bin\Autodesk.DataManagement.Client.Framework.xml"
	File "bin\DevExpress.Data.v12.1.dll"
	File "bin\DevExpress.Office.v12.1.Core.dll"
	File "bin\DevExpress.Printing.v12.1.Core.dll"
	File "bin\DevExpress.RichEdit.v12.1.Core.dll"
	File "bin\DevExpress.Utils.v12.1.dll"
	File "bin\DevExpress.XtraBars.v12.1.dll"
	File "bin\DevExpress.XtraEditors.v12.1.dll"
	File "bin\DevExpress.XtraGrid.v12.1.dll"
	File "bin\DevExpress.XtraLayout.v12.1.dll"
	File "bin\DevExpress.XtraPrinting.v12.1.dll"
	File "bin\DevExpress.XtraTreeList.v12.1.dll"
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
	Delete "$INSTDIR\bin\Autodesk.Connectivity.Explorer.Extensibility.dll"
	Delete "$INSTDIR\bin\Autodesk.Connectivity.Explorer.Extensibility.xml"
	Delete "$INSTDIR\bin\Autodesk.Connectivity.Explorer.ExtensibilityTools.dll"
	Delete "$INSTDIR\bin\Autodesk.Connectivity.Explorer.ExtensibilityTools.xml"
	Delete "$INSTDIR\bin\Autodesk.Connectivity.Extensibility.Framework.dll"
	Delete "$INSTDIR\bin\Autodesk.Connectivity.Extensibility.Framework.xml"
	Delete "$INSTDIR\bin\Autodesk.Connectivity.JobProcessor.Extensibility.dll"
	Delete "$INSTDIR\bin\Autodesk.Connectivity.JobProcessor.Extensibility.xml"
	Delete "$INSTDIR\bin\Autodesk.Connectivity.WebServices.dll"
	Delete "$INSTDIR\bin\Autodesk.Connectivity.WebServices.xml"
	Delete "$INSTDIR\bin\Autodesk.DataManagement.Client.Framework.dll"
	Delete "$INSTDIR\bin\Autodesk.DataManagement.Client.Framework.Forms.dll"
	Delete "$INSTDIR\bin\Autodesk.DataManagement.Client.Framework.Forms.xml"
	Delete "$INSTDIR\bin\Autodesk.DataManagement.Client.Framework.Vault.dll"
	Delete "$INSTDIR\bin\Autodesk.DataManagement.Client.Framework.Vault.Forms.dll"
	Delete "$INSTDIR\bin\Autodesk.DataManagement.Client.Framework.Vault.Forms.xml"
	Delete "$INSTDIR\bin\Autodesk.DataManagement.Client.Framework.Vault.xml"
	Delete "$INSTDIR\bin\Autodesk.DataManagement.Client.Framework.xml"
	Delete "$INSTDIR\bin\DevExpress.Data.v12.1.dll"
	Delete "$INSTDIR\bin\DevExpress.Office.v12.1.Core.dll"
	Delete "$INSTDIR\bin\DevExpress.Printing.v12.1.Core.dll"
	Delete "$INSTDIR\bin\DevExpress.RichEdit.v12.1.Core.dll"
	Delete "$INSTDIR\bin\DevExpress.Utils.v12.1.dll"
	Delete "$INSTDIR\bin\DevExpress.XtraBars.v12.1.dll"
	Delete "$INSTDIR\bin\DevExpress.XtraEditors.v12.1.dll"
	Delete "$INSTDIR\bin\DevExpress.XtraGrid.v12.1.dll"
	Delete "$INSTDIR\bin\DevExpress.XtraLayout.v12.1.dll"
	Delete "$INSTDIR\bin\DevExpress.XtraPrinting.v12.1.dll"
	Delete "$INSTDIR\bin\DevExpress.XtraTreeList.v12.1.dll"

	; Remove remaining directories
	RMDir "$SMPROGRAMS\ZippyBytes\ZippyConsole"
	RMDir "$INSTDIR\bin\"
	RMDir "$INSTDIR\"

SectionEnd

; eof