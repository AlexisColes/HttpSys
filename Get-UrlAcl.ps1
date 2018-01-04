Function Get-UrlAcl {
    [CmdletBinding()] 
    Param( 
        [Parameter(Position=0)]
        [string]$Url
    )

    $cmd = "netsh http show urlacl"
    if(-not [string]::IsNullOrWhiteSpace($Url)){
        $cmd += " url=$Url"
    }

    $result = Invoke-Expression $cmd

    $result = $result | Select-Object -Skip 4

    $items = @()
    $item = [UrlAcl]::new()
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
            $item = [UrlAcl]::new()
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
    return $items
}

Class UrlAcl{
    [string]$Url
    [UrlAclUser[]]$Users
}
Class UrlAclUser{
    [string]$Name
    [boolean]$Listen
    [boolean]$Delegate
    [string]$SSDL
}