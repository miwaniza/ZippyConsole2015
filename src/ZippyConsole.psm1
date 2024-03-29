#######################################################################################################################
# File:             ZippyConsole.psm1                                                                                 #
# Author:           Dmitry Yemelyanov aka miwaniza                                                                    #
# Publisher:        Dmitry Yemelyanov                                                                                 #
# Copyright:        © 2014 Dmitry Yemelyanov. All rights reserved.                                                    #
# Usage:            Run Get-Command -Module ZippyConsole to get all available commands.                               #
#                   Run Connect-VaultVDF to connect to Vault server with GUI dialog.                                  #
#                   Run Connect-VaultCMD to connect to Vault server with command prompt.                              #
#                   After connection run Get-VaultVariables to get variables with name like "*v*lt*".                 #
#                   Please provide feedback on the PowerGUI Forums.                                                   #
#######################################################################################################################


param()
#Set-StrictMode -Version 2
Add-Type -Path (Join-Path $PSScriptRoot "bin\Autodesk.DataManagement.Client.Framework.Vault.Forms.dll")
Add-Type -Path (Join-Path $PSScriptRoot "bin\Autodesk.Connectivity.WebServices.dll")


function prompt
{
    "<"+$vltActiveConn.get_Server()+ ">[" + $vltActiveConn.get_Vault() +"]{" + $vltActiveConn.get_UserName() +"} " + $vltFolderCurrent.FullName + "> "
    $host.ui.RawUI.WindowTitle = "You are logged on `"" + $vltActiveConn.get_Server()+ "`" server to `"" + $vltActiveConn.get_Vault() +"`" vault as `"" + $vltActiveConn.get_UserName() + "`" user"
}

Function Get-FilePath($initialDirectory)
{   
 [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
 Out-Null

 $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
 $OpenFileDialog.initialDirectory = $initialDirectory
 $OpenFileDialog.filter = "All files (*.*)| *.*"
 $OpenFileDialog.ShowDialog() | Out-Null
 $OpenFileDialog.filename
}


function Disconnect-Vault
{

param(
		[Parameter(Position=0, Mandatory=$false)]
		[ValidateNotNullOrEmpty()]
		[Autodesk.Connectivity.WebServicesTools.WebServiceManager]
		$vltCon
	)

switch ($args.Count)
{
    0 {$vltActiveConn.Dispose()
        $vltActiveConn = $null}
    1 {$vltCon.Dispose()
       $vltCon = $null }
    Default {}
}

<#
            .SYNOPSIS 
            Disposes vault connection and sets it to NULL.

            .DESCRIPTION
            Disposes vault connection.

            .INPUTS
            None or certain connection. If no input - disposing active connection.

            .OUTPUTS
            None.

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Disconnect-Vault

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Disconnect-Vault $vltCon

            .LINK
            http://www.zippybytes.com

            .LINK
            Connect-VaultCMD
            Connect-VaultVDF
            Get-VaultConnection
            #>

}


function Set-VaultVariables
{
    Set-Variable -Name vltAdminSvc -Value $vltActiveConn.WebServiceManager.AdminService -Scope Global -Description "Contains methods for manipulating users and groups."
    Set-Variable -Name vltDocumentSvc -Value $vltActiveConn.WebServiceManager.DocumentService -Scope Global -Description "Contains methods for manipulating files and folders within a vault."
    Set-Variable -Name vltFilestoreSvc -Value $vltActiveConn.WebServiceManager.FilestoreService -Scope Global -Description "A service for uploading and downloading binary file data."
    Set-Variable -Name vltUsers -Value $vltAdminSvc.GetAllUsers() -Scope Global -Description "List of all Vault users. AdminUserRead required."
    Set-Variable -Name vltRoles -Value $vltAdminSvc.GetAllRoles() -Scope Global -Description "List of all Vault roles. AdminUserRead required."
    Set-Variable -Name vltGroups -Value $vltAdminSvc.GetAllGroups() -Scope Global -Description "List of all Vault groups. AdminUserRead required."
    Set-Variable -Name vltFolderRoot -Value $vltActiveConn.WebServiceManager.AdminService -Scope Global -Description "Contains methods for manipulating users and groups."
    
    <#
            .SYNOPSIS 
            Activates Vault variables in PowerShell.

            .DESCRIPTION
            Activates Vault variables in PowerShell.

            .INPUTS
            None.

            .OUTPUTS
            None.

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Set-VaultVariables

            .LINK
            http://www.zippybytes.com

            .LINK
            Get-VaultVariables
            Get-VaultVariablesDescriptions
            Connect-VaultCMD
            Connect-VaultVDF
            Get-VaultConnection
            #>
}


function Set-VaultLocation
{
switch ($args.Count)
{

    0 { $fldr = $vltFolderCurrent }
    1 {
        $folderName = $args[0].ToString()
        if($folderName -like "$*") { $fldr = $vltDocumentSvc.GetFolderByPath($folderName) }
        elseif($folderName -eq "..") { if ($vltFolderCurrent.ParId -eq -1) {$fldr = $vltDocumentSvc.GetFolderRoot()} else {$fldr = $vltDocumentSvc.GetFolderById($vltFolderCurrent.ParId)} }
        elseif($folderName -eq "/") { $fldr = $vltDocumentSvc.GetFolderRoot() }
        else { $fldr = $vltDocumentSvc.GetFoldersByParentId($vltFolderCurrent.ID, $false) | Where-Object {$_.Name -eq $folderName} }
      }
    Default {}
}
Set-Variable -Name vltFolderCurrent -Value $fldr -Scope Global -Description "Working folder in current Vault."
$vltFolderCurrent
    <#
            .SYNOPSIS 
            Sets the current working Vault location to a specified location.

            .DESCRIPTION
            Sets the current working Vault location to a specified location like cd command.

            .INPUTS
            None or certain connection. If no input - disposing active connection.

            .OUTPUTS
            vltFolderCurrent

            .EXAMPLE
            Set-VaultLocation $

            .EXAMPLE
            Set-VaultLocation ..

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $/Design Data> Set-VaultLocation /
			
			.EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $/Design Data/Project1> Set-VaultLocation ..

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Set-VaultLocation $/Design

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $/Design Data> Set-VaultLocation Project1
			
            .LINK
            http://www.zippybytes.com

            .LINK
            Get-VaultVariables
            Get-VaultVariablesDescriptions
            Connect-VaultCMD
            Connect-VaultVDF
            Get-VaultConnection
    #>

}



function Get-VaultChildItem
{

[OutputType([Autodesk.Connectivity.WebServices.FileFolder])]
$vltObjects = $null
$total = 0
$global:vltFolders = $vltDocumentSvc.GetFoldersByParentId($vltFolderCurrent.ID, $false)
$vltObjects += $vltFolders #| Format-Table -Property Name, CreateDate
$total += $vltFolders.Count
$global:vltFiles = $vltDocumentSvc.GetLatestFilesByFolderId($vltFolderCurrent.ID, $false)
$vltObjects += $vltFiles #| Format-Table -Property Name, CkInDate -HideTableHeaders
$vltObjects
#$total += $vltFiles.Count
if($total -eq 0){"Folder is empty"}

    <#
            .SYNOPSIS 
            Returns files and folders for current Vault folder.

            .DESCRIPTION
            Returns files and folders for current Vault folder.

            .INPUTS
            None. You cannot pipe objects to Get-VaultChildItem.

            .OUTPUTS
            Autodesk.Connectivity.WebServices.FileFolder. Get-VaultChildItem returns an array of FileFolder objects.

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Get-VaultFolderChildren | Format-Table -Parameter ('Name','CheckinDate', 'FileSize')

            .LINK
            http://www.zippybytes.com

            .LINK
            Get-VaultConnection
    #>
}


function Initialize-ZippyConsole
{

Set-VaultVariables
Set-VaultLocation "/" | Out-Null
    
    <#
            .SYNOPSIS 
            Initializes variables and sets active folder to vault root.

            .DESCRIPTION
            Initializes variables and sets active folder to vault root.

            .INPUTS
            None. You cannot pipe objects to Get-VaultChildItem.

            .OUTPUTS
            None.

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Initialize-ZippyConsole

            .LINK
            http://www.zippybytes.com

            .LINK
            Set-VaultVariables
            Set-VaultLocation
    #>

}

function Add-VaultFolder 
{
	[OutputType([Autodesk.Connectivity.WebServices.Folder])]
    param(
		[Parameter(Position=0, Mandatory=$true)]
		[System.String]
		$name,

		[Parameter(Position=1, Mandatory=$false)]
		[System.String]
		$parentPath
	)

$parentPath

if (($parentPath -eq "") -or ($parentPath -eq $null)) {$parentPath = $vltFolderCurrent.FullName}

    try {
    $pFolder = $vltDocumentSvc.GetFolderByPath($parentPath)
    $newFolder = $vltDocumentSvc.AddFolder($name, $pFolder.ID, $false)
    $newFolder
    }

    catch {
		    throw
	    }
    <#
            .SYNOPSIS 
            Creates new simple folder in vault.

            .DESCRIPTION
            Creates new simple folder in vault.

            .INPUTS
            Folder name and path to parent folder (not mandatory).

            .OUTPUTS
            Created folder object.

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Add-VaultFolder

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Add-VaultFolder Design1

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Add-VaultFolder "Design 119"

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Add-VaultFolder -name "Design 119" -parentPath "$/Design"

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Add-VaultFolder Design1 $/Designs

            .LINK
            http://www.zippybytes.com

            .LINK
            Add-VaultFolderLibrary
    #>

}

function Add-VaultFolderLibrary
{
	[OutputType([Autodesk.Connectivity.WebServices.Folder])]
    param(
		[Parameter(Position=0, Mandatory=$true)]
		[System.String]
		$name,

		[Parameter(Position=1, Mandatory=$false)]
		[System.String]
		$parentPath
	)

$parentPath

if (($parentPath -eq "") -or ($parentPath -eq $null)) {$parentPath = $vltFolderCurrent.FullName}

    try {
    $pFolder = $vltDocumentSvc.GetFolderByPath($parentPath)
    $newFolder = $vltDocumentSvc.AddFolder($name, $pFolder.ID, $true)
    $newFolder
    }

    catch {
		    throw
	    }
    <#
            .SYNOPSIS 
            Creates new library folder in vault.

            .DESCRIPTION
            Creates new library folder in vault.

            .INPUTS
            Folder name and path to parent folder (not mandatory).

            .OUTPUTS
            Created folder object.

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Add-VaultFolderLibrary ContentCenter

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Add-VaultFolderLibrary "Content Center"

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Add-VaultFolderLibrary Design1 $/Designs

            .LINK
            http://www.zippybytes.com

            .LINK
            Add-VaultFolder
    #>

}

function Get-VaultFolder
{
    [CmdletBinding()]
	[OutputType([Autodesk.Connectivity.WebServices.Folder])]
    param(
		[Parameter(Position=0, Mandatory=$false)]
		[System.String]
		$folderName
	)

if (($folderName -eq $null) -or ($folderName -eq "")) { $fldr = $vltFolderCurrent; "0" }
else {
        if($folderName -like "$*") { $fldr = $vltDocumentSvc.GetFolderByPath($folderName) }
        elseif($folderName -eq "..") { if ($vltFolderCurrent.ParId -eq -1) {$fldr = $vltDocumentSvc.GetFolderRoot()} else {$fldr = $vltDocumentSvc.GetFolderById($vltFolderCurrent.ParId)} }
        elseif($folderName -eq "/") { $fldr = $vltDocumentSvc.GetFolderRoot() }
        else { $fldr = $vltDocumentSvc.GetFoldersByParentId($vltFolderCurrent.ID, $false) | Where-Object {$_.Name -eq $folderName} }
      }
    
$fldr

<#
            .SYNOPSIS 
            Gets folder object in vault by path.

            .DESCRIPTION
            Gets folder object in vault by path.

            .INPUTS
            Folder name or path (not mandatory).

            .OUTPUTS
            Folder object.

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Get-VaultFolder

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Get-VaultFolder ..

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Get-VaultFolder $

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Get-VaultFolder /

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Get-VaultFolder $/Design/135

            .LINK
            http://www.zippybytes.com

            .LINK
            Add-VaultFolder
    #>

}

function Connect-VaultVDF
{
    [OutputType([Autodesk.DataManagement.Client.Framework.Vault.Currency.Connections.Connection])]
	param(
		[Parameter(Position=0, Mandatory=$false)]
		[ValidateNotNullOrEmpty()]
		[System.Boolean]
		$PassThru
	)
	
	$dialogResult = [Autodesk.DataManagement.Client.Framework.Vault.Forms.Library]::Login($null)
    Set-Variable -Name vltActiveConn -Value $dialogResult -Scope Global -Description "Active vault connection."
	Initialize-ZippyConsole
	if ($PassThru){	return $vltActiveConn }
	else {return $null}
<#
            .SYNOPSIS 
            Connect to Vault using VDF dialog.

            .DESCRIPTION
            Connect to Vault using VDF dialog.

            .INPUTS
            None.

            .OUTPUTS
            Vault active connection.

            .EXAMPLE
            Connect-VaultVDF
			
			.EXAMPLE
            PS> Connect-VaultVDF -PassThru 1

            .LINK
            http://www.zippybytes.com

            .LINK
            Connect-VaultCMD
            Get-VaultAllConnections
    #>

}

function Connect-VaultCMD {
	
	[OutputType([Autodesk.DataManagement.Client.Framework.Vault.Currency.Connections.Connection])]
	param(
		[Parameter(Position=0, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[System.String]
		$serverName,

		[Parameter(Position=1, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[System.String]
		$vaultName,
		
		[Parameter(Position=2, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[System.String]
		$userName,

        [Parameter(Position=3, Mandatory=$false)]
		[ValidateNotNullOrEmpty()]
		[System.String]
		$password,
		
		[Parameter(Position=4, Mandatory=$false)]
		[ValidateNotNullOrEmpty()]
		[System.Boolean]
		$PassThru
	)
    if (($password -eq $null) -or ($password -eq "")) {$sappword = Read-Host -Prompt "Enter your Vault password" -AsSecureString
	
	$STRB335 = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($sappword)
	$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($STRB335)}
	$cred = New-Object Autodesk.Connectivity.WebServicesTools.UserPasswordCredentials ($serverName, $vaultName, $userName, $password)	
	$websvc = New-Object Autodesk.Connectivity.WebServicesTools.WebServiceManager ($cred)
	$dialogResult = New-Object Autodesk.DataManagement.Client.Framework.Vault.Currency.Connections.Connection ($websvc,`
		$userName,`
		$password,`
		$vaultName,`
		$websvc.SecurityService.SecurityHeader.UserId,`
		$serverName,`
		[Autodesk.DataManagement.Client.Framework.Vault.Currency.Connections.AuthenticationFlags]::Standard)
    Set-Variable -Name vltActiveConn -Value $dialogResult -Scope Global -Description "Active vault connection."
	Initialize-ZippyConsole
    if ($PassThru){	return $vltActiveConn }
	else {return $null}
    <#
            .SYNOPSIS 
            Connect to Vault using command prompt.

            .DESCRIPTION
            Connect to Vault using VDF dialog.

            .INPUTS
            None.

            .OUTPUTS
            Vault active connection.

            .EXAMPLE
            PS> Connect-VaultCMD
            
            .EXAMPLE
            PS> Connect-VaultCMD -serverName vaultSrv:8080 -vaultName Zippy

            .EXAMPLE
            PS> Connect-VaultCMD -PassThru 1

            .LINK
            http://www.zippybytes.com

            .LINK
            Connect-VaultVDF
            Get-VaultAllConnections
    #>
}

function Get-VaultAllConnections
{
$vaultCons = Get-Variable | Where-Object {$_.Value -like 'Autodesk*Connection'}
$vaultCons

<#
            .SYNOPSIS 
            Returns all current vault connections.

            .DESCRIPTION
            Returns all current vault connections.

            .INPUTS
            None.

            .OUTPUTS
            Vault active connections.

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Get-VaultAllConnections
            
            .LINK
            http://www.zippybytes.com

            .LINK
            Connect-VaultVDF
            Connect-VaultCMD
    #>

}

function Add-VaultFile
{

param(
		[Parameter(Position=0, Mandatory=$false)]
		[System.String]
		$filePath
	)

if (($filePath -eq "") -or ($filePath -eq $null)) {$fp =  Get-FilePath "c:/"} else { $fp = $filePath}


$fileFromDisk = New-Object Autodesk.DataManagement.Client.Framework.Currency.FilePathAbsolute $fp
$fold = New-Object Autodesk.DataManagement.Client.Framework.Vault.Currency.Entities.Folder $vltActiveConn, $vltFolderCurrent
    
	$vltActiveConn.FileManager.AddFile(
		$fold,
		"SMTH",
		$null,
		$null,
		[Autodesk.Connectivity.WebServices.FileClassification]::DesignVisualization,
		$false,
		$fileFromDisk)

<#
            .SYNOPSIS 
            Adds a file from disk to current vault folder.

            .DESCRIPTION
            Adds a file from disk to current vault folder.

            .INPUTS
            File path.

            .OUTPUTS
            New Vault file object.

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Add-VaultFile

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Add-VaultFile c:/1.txt
            
            .LINK
            http://www.zippybytes.com

            .LINK
            Connect-VaultVDF
            Connect-VaultCMD
    #>

}

function Add-VaultFileHidden
{

param(
		[Parameter(Position=0, Mandatory=$false)]
		[System.String]
		$filePath
	)

if (($filePath -eq "") -or ($filePath -eq $null)) {$fp =  Get-FilePath "c:/"} else { $fp = $filePath}

$fileFromDisk = New-Object Autodesk.DataManagement.Client.Framework.Currency.FilePathAbsolute $fp
$fold = New-Object Autodesk.DataManagement.Client.Framework.Vault.Currency.Entities.Folder $vltActiveConn,$vltFolderCurrent
    
	$vltActiveConn.FileManager.AddFile(
		$fold,
		$null,
		$null,
		$null,
		[Autodesk.Connectivity.WebServices.FileClassification]::DesignVisualization,
		$true,
		$fileFromDisk)

<#
            .SYNOPSIS 
            Adds a file from disk to current vault folder as hidden.

            .DESCRIPTION
            Adds a file from disk to current vault folder as hidden.

            .INPUTS
            File path.

            .OUTPUTS
            New Vault file object.

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Add-VaultFile

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Add-VaultFile c:/1.txt
            
            .LINK
            http://www.zippybytes.com

            .LINK
            Connect-VaultVDF
            Connect-VaultCMD
    #>

}


function Set-VaultActiveConnection
{

param(
		[Parameter(Position=0, Mandatory=$false)]
		[System.String]
		$filePath
	)

    $vltActiveConn = $vltConn
    Initialize-ZippyConsole

    <#
            .SYNOPSIS 
            Sets active connection to selected.

            .DESCRIPTION
            Sets active connection to selected.

            .INPUTS
            File path.

            .OUTPUTS
            New Vault file object.

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Set-VaultActiveConnection $conn1
            
            .LINK
            http://www.zippybytes.com

            .LINK
            Connect-VaultVDF
            Connect-VaultCMD
    #>
}

function Get-ZippyConsoleHelp
{
[System.Console]::Title = "ZippyConsole v1.0"
Write-Host ( "You are welcome to ZippyConsole v1.0!") 
Write-Host ( "Run ") -NoNewline; write-host ("Get-Command -Module ZippyConsole") -ForegroundColor Yellow -NoNewline; Write-Host (" to get all available commands.")
Write-Host ( "Run ") -NoNewline; write-host ("Connect-VaultVDF") -ForegroundColor Yellow -NoNewline; Write-Host (" to connect to Vault server with GUI dialog.")
Write-Host ( "Run ") -NoNewline; write-host ("Connect-VaultCMD") -ForegroundColor Yellow -NoNewline; Write-Host (" to connect to Vault server with command prompt.")
Write-Host ( "After connection run ") -NoNewline; write-host ("Get-VaultVariables") -ForegroundColor Yellow -NoNewline; Write-Host (" to get variables with name like `"*v*lt*`".")
}

function Get-VaultVariables
{
Get-Variable | Where-Object {$_.Name -like "*v*lt*"}

	<#
            .SYNOPSIS 
            Gets ZippyConsole variables.

            .DESCRIPTION
            Gets ZippyConsole variables.

            .INPUTS
            None.

            .OUTPUTS
            Vault variable object.

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Get-VaultVariables
            
            .LINK
            http://www.zippybytes.com

            .LINK
            Connect-VaultVDF
            Connect-VaultCMD
    #>
}

function Get-VaultVariablesDescriptions
{
Get-VaultVariables | Select-Object -Property Name, Description

	<#
            .SYNOPSIS 
            Gets Vault descriptions of ZippyConsole variables.

            .DESCRIPTION
            Gets Vault descriptions of ZippyConsole variables.

            .INPUTS
            None.

            .OUTPUTS
            Vault variables descriptions.

            .EXAMPLE
            <srv_pko1:8080>[zippybytes]{zippy} $> Get-VaultVariables
            
            .LINK
            http://www.zippybytes.com

            .LINK
            Connect-VaultVDF
            Connect-VaultCMD
    #>
}