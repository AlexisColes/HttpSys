# HttpSys Powershell and DSC module

## Powershell

### Get-UrlAcl Examples

```powershell
Get-UrlAcl -Url http://+:69/

Get-UrlAcl -Port 69

Get-UrlAcl -Protocol http

Get-UrlAcl -HostName *

Get-UrlAcl -Port $(6969..6980)
```

### New-UrlAcl Examples

```powershell
New-UrlAcl -Protocol http -HostName + -Port 69 -SecurityContext Everyone

New-UrlAcl -Protocol http -HostName + -Port 69 -Path SomeSubPath -SecurityContext Everyone
```

### Remove-UrlAcl Examples

```powershell
Get-UrlAcl -Url http://+:69/ | Remove-UrlAcl

Get-UrlAcl -Port 69 | Remove-UrlAcl
```

### DSC Resource

```powershell
Configuration UrlAcltest {
    Import-DscResource -ModuleName HttpSys -ModuleVersion 1.0.2

    node $env:COMPUTERNAME {
        UrlAcl UrlAclTestResource {
            Name = "UrlAclTestResource"
            HostName = "+"
            Port = $(6969..6971)
            Protocol = "Http"
            SecurityContext = "NT AUTHORITY\LOCAL SERVICE"
        }
        UrlAcl UrlAclTestResource {
            Name = "UrlAclTestResource2"
            HostName = "+"
            Port = 6972
            Protocol = "Https"
            Path = "/somePath/"
            SecurityContext = "NT SERVICE\TermService"
        }
    }
}
```