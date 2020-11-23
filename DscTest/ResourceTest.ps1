. $PSScriptRoot\..\Module\Get-UrlAcl.ps1
. $PSScriptRoot\..\Module\Remove-UrlAcl.ps1
. $PSScriptRoot\..\Module\New-UrlAcl.ps1

[DscResource()]
class UrlAcl {
	[DscProperty(Key)]
    [string]$Name
    
	[DscProperty()]
    [string]$Protocol
	
	[DscProperty()]
	[string]$HostName

	[DscProperty()]
    [string]$SecurityContext
    
	[DscProperty()]
    [int[]]$Port
    
	[DscProperty()]
    [string]$Path = "/"

	[DscProperty()]
    [bool]$Ensure

	[UrlAcl]Get(){
		return $this
	}
	[bool]Test(){
        $result = $true
        $urlAcls = Get-UrlAcl -Port $this.Port -HostName $this.HostName -Protocol $this.Protocol -Path $this.Path

        if($this.Port -isnot [System.Array]){
            $this.Port = @($this.Port)
        }

        foreach($p in $this.Port)
        {
            $url = $this.FormatUrl($this.Protocol, $this.HostName, $P, $this.Path)

            $acl = $urlAcls | Where-Object { $_.Port -eq $p }
            
            if($null -eq $acl){
                Write-Verbose "No urlacl found for $url"
                $result = $false;
                continue;
            }

            $resourceUsers = $this.SecurityContext -split ',' | ForEach-Object { $_.Trim() }

            foreach($user in $resourceUsers){
                if($null -eq ($acl.users | Where-Object { $_.Name -eq $user })){
                    Write-Verbose "SecurityContext of $($user) not set on: $url"
                    $result = $false
                }
            }

            foreach($user in $this.users){
                if($null -eq ($resourceUsers | Where-Object { $_ -eq $user.Name })){
                    Write-Verbose "SecurityContext of $($user) set on: $url, but not supplied in parameters"
                    $result = $false
                }
            }
        }

        return $result;
	}
	[void]Set(){
        foreach($p in $this.Port)
        {
            $url = $this.FormatUrl($this.Protocol, $this.HostName, $p, $this.Path)

            Write-Verbose "Finding $url"
            $acl = Get-UrlAcl -Url $url

            if($null -ne $acl){
                Write-Verbose "Removing $url"
                $acl | Remove-UrlAcl
            }

            New-UrlAcl -Protocol $this.Protocol -HostName $this.HostName -Port $p -Path $this.Path -SecurityContext $this.SecurityContext
        }
    }
    
    [string]FormatUrl([string]$protocol, [string]$hostName, [string]$port, [string]$path){
        Write-Verbose "Formatting"
        return "$($protocol.Trim())://$($hostName.Trim()):$($port.Trim())$($path.Trim())"
    }
}

$VerbosePreference = "Continue"

$resource = [UrlAcl]::new()

$resource.Protocol = "http"
$resource.Hostname = "*"
$resource.Port = "5357"
$resource.SecurityContext = "BUILTIN\Users,NT AUTHORITY\LOCAL SERVICE"

$resource.Test()
