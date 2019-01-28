# Get-Module HttpSys | Remove-Module
# $moduleFolder = get-item $PSScriptRoot\..\..\HttpSys
# $moduleFolder.FullName
# Import-Module $moduleFolder.FullName


Configuration UrlAcltest {
    Import-DscResource -ModuleName HttpSys -ModuleVersion 1.0.1

    node $env:COMPUTERNAME {
        UrlAcl UrlAclTestResource {
            Name = "UrlAclTestResource"
            HostName = "+"
            Port = $(6969..6971)
            Protocol = "Http"
            SecurityContext = "$($node.NodeName)\URLACLPermitted"
        }
    }
}

UrlAclTest -OutputPath "$psscriptroot\Mof" -Verbose

$dscProcessID = Get-WmiObject msft_providers |
Where-Object {$_.provider -like 'dsccore'} |
Select-Object -ExpandProperty HostProcessIdentifier
Get-Process -Id $dscProcessID | Stop-Process -Force

Start-DscConfiguration -ComputerName $env:COMPUTERNAME -Path "$psscriptroot\Mof" -Force -Wait -Verbose