#
# Module manifest for module 'DeploymentClass'
#
# Generated by: Alexis.Coles
#
# Generated on: 9/14/2015
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'HttpSys.psm1'

# Version number of this module.
ModuleVersion = '1.0.2'

# ID used to uniquely identify this module
GUID = 'dc6db6aa-9f02-4f9c-bf58-8c15ec06588c'

# Author of this module
Author = 'Alexis.Coles'

# Company or vendor of this module
CompanyName = 'Spreadex Ltd'

# Copyright statement for this module
Copyright = '(c) 2015 Alexis.Coles. All rights reserved.'

# Description of the functionality provided by this module
Description = 'DSC for HttpSys stuff'

# Functions to export from this module
FunctionsToExport = '*'

# Cmdlets to export from this module

CmdletsToExport = @(
	'Get-UrlAcl',
	'New-UrlAcl',
	'Remove-UrlAcl'
)

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module
AliasesToExport = '*'

# DSC resources to export from this module
#DscResourcesToExport = 'SxWindowsService', 'SxWebSite', 'PsPackageSource', 'PsModule', 'SxWinClient', 'PsPackage', 'PsPackageProvider', 'FilebeatWindowsService'
DscResourcesToExport = @(
	'UrlAcl'
)

PrivateData = @{
		PSData = @{
            # The web address of this module's project or support homepage.
			ProjectUri   = "https://github.com/AlexisColes/HttpSys"
			
            ReleaseNotes = 'https://github.com/AlexisColes/HttpSys/releases/tag/1.0.2'
		}
	}
}
