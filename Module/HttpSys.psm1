. $PSScriptRoot\Get-UrlAcl.ps1
. $PSScriptRoot\Remove-UrlAcl.ps1
. $PSScriptRoot\New-UrlAcl.ps1

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
        $urlAcls = Get-UrlAcl -Port $this.Port -HostName $this.HostName -Protocol $this.Protocol

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

            if($null -eq ($acl.users | Where-Object { $_.Name -eq $this.SecurityContext })){
                Write-Verbose "SecurityContext of $($this.SecurityContext) not set on: $url"
                $result = $false
                continue;
            }
        }

        return $result;
	}
	[void]Set(){
        foreach($p in $this.Port)
        {
            $url = $this.FormatUrl($this.Protocol, $this.HostName, $p, $this.Path)

            $acl = Get-UrlAcl -Url $url

            if($null -ne $acl){
                $acl | Remove-UrlAcl
            }

            New-UrlAcl -Protocol $this.Protocol -HostName $this.HostName -Port $p -Path $this.Path -SecurityContext $this.SecurityContext
        }
    }
    
    [string]FormatUrl([string]$protocol, [string]$hostName, [string]$port, [string]$path){
        return "${protocol}://${hostName}:$port$path"
    }
}