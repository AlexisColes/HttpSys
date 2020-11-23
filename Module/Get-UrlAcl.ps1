
Function Get-UrlAcl {
    [CmdletBinding()] 
    Param( 
        [Parameter(Position=0)]
        [string]$Url,
        [Parameter()]
        [int[]]$Port,
        [Parameter()]
        [string]$HostName,
        [Parameter()]
        [string]$Protocol,
        [Parameter()]
        [string]$Path
    )

    if($Protocol) { $Protocol = $Protocol.Trim() }
    if($HostName) { $HostName = $HostName.Trim() }
    if($Path) { $Path = $Path.Trim() }
    if($SecurityContext) { $SecurityContext = $SecurityContext.Trim() }

    $cmd = "netsh http show urlacl"
    if(-not [string]::IsNullOrWhiteSpace($Url)){
        $cmd += " url=$Url"
    }

    $result = Invoke-Expression $cmd

    $result = $result | Select-Object -Skip 4

    $items = @()
    $item = [UrlAclDto]::new()
    $user = [UrlAclUser]::new()
    for($i = 0; $i -lt $result.Length;$i++){
        $line = $result[$i]
        if([string]::IsNullOrWhiteSpace($line)){
            continue;
        }
        $splitIndex = $line.IndexOf(": ");
        $key = $line.Substring(0,$splitIndex).Trim();
        $value = $line.Substring($splitIndex +2);
        
        if($key -eq "Reserved Url"){
            $item = [UrlAclDto]::new()
            $protocolSplitIndex = $value.IndexOf("://");
            $item.Protocol = $value.Substring(0, $protocolSplitIndex)
            $remainder = $value.Substring($protocolSplitIndex + 3)

            $pathSplitIndex = $remainder.IndexOf("/")

            $hostDetails = $remainder.Substring(0, $pathSplitIndex)
            
            $hostParts = $hostDetails.Split(':')

            $item.Host = $hostParts[0]
            $item.Port = $hostParts[1]

            $item.Path = $remainder.Substring($pathSplitIndex).Trim()

            $item.Url = $value
            $items += $item
        }
        if($key -eq "User"){            
            $user = [UrlAclUser]::new()
            $user.Name = $value
            $item.Users += $user
        }
        if($key -eq "Listen"){
            $user.Listen = if($value -eq "Yes") { $true } else { $false }
        }
        if($key -eq "Delegate"){
            $user.Delegate = if($value -eq "Yes") { $true } else { $false }
        }
        if($key -eq "SDDL"){
            $user.SSDL = $value
        }
    }
    if(-not [string]::IsNullOrWhiteSpace($HostName)){
        $items = $items | Where-Object { $_.Host -eq $HostName }
    }
    if(-not [string]::IsNullOrWhiteSpace($Protocol)){
        $items = $items | Where-Object { $_.Protocol -eq $Protocol }
    }

    if($null -ne $Port){
        if($Port -isnot [System.Array]){
            $Port = @($Port)
        }
        if($Port.Length -ge 0){
            $items = $items | Where-Object { $Port -contains $_.Port }
        }
    }
    if(-not [string]::IsNullOrWhiteSpace($Path)){
        $items = $items | Where-Object { $_.Path.Trim() -eq $Path.Trim() }
    }

    return $items
}

Class UrlAclDto{
    [string]$Protocol
    [string]$Host
    [int]$Port    
    [string]$Path
    [string]$Url
    [UrlAclUser[]]$Users    
}
Class UrlAclUser{
    [string]$Name
    [boolean]$Listen
    [boolean]$Delegate
    [string]$SSDL
}