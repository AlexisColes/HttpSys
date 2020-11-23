Get-Module | Where-Object {$_.Name -eq "HttpSys"} | Remove-Module
$source = "$PSScriptRoot\..\Module"
Import-LocalizedData -BaseDirectory $source -FileName HttpSys.psd1 -BindingVariable ModuleInfo
$targetDirectory = "$env:ProgramFiles\WindowsPowerShell\Modules\HttpSys\$($ModuleInfo.ModuleVersion)"
if(Test-Path $targetDirectory){
    Remove-Item $targetDirectory -Force -Recurse
}
New-Item $targetDirectory -ItemType Directory -Force
Get-ChildItem $source | Copy-Item -Destination $targetDirectory


Configuration UrlAcltest {
    Import-DscResource -ModuleName HttpSys -ModuleVersion 1.0.2

    node $env:COMPUTERNAME {
        UrlAcl UrlAclTestResource {
            Name = "UrlAclTestResource"
            HostName = "+"
            Port = $(6969..6971)
            Protocol = "Http"
            Path = "/somePath/"
            #SecurityContext = "NT AUTHORITY\LOCAL SERVICE"
            SecurityContext = "NT SERVICE\TermService"
        }
    }
}

UrlAclTest -OutputPath "$PSScriptRoot\Mof" -Verbose

# $dscProcessID = Get-WmiObject msft_providers |
# Where-Object {$_.provider -like 'dsccore'} |
# Select-Object -ExpandProperty HostProcessIdentifier
# Get-Process -Id $dscProcessID | Stop-Process -Force

Start-DscConfiguration -ComputerName $env:COMPUTERNAME -Path "$psscriptroot\Mof" -Force -Wait -Verbose