Function New-UrlAcl {
    [CmdletBinding()] 
    Param( 

        [Parameter(Mandatory=$true)]
        [string]$Protocol,
        [Parameter(Mandatory=$true)]
        [string]$HostName,
        [Parameter(Mandatory=$true)]
        [int[]]$Port,
        [Parameter(Mandatory=$false)]
        [string]$Path = "/",
        [Parameter(Mandatory=$true)]
        [string]$SecurityContext
    )

    if($UrlAcl -isnot [System.Array]){
        $UrlAcl = @($UrlAcl)
    }

    $baseCmd = "netsh http add urlacl"

    if(-not $Path.StartsWith("/")){
        $Path = "/$Path"
    }
    if(-not $Path.EndsWith("/")){
        $Path = "$Path/"
    }
    
    $url = "${Protocol}://${HostName}:$Port$Path"

    $cmd = "$baseCmd url=$url user=""$SecurityContext"""
    
    $result = Invoke-Expression $cmd

    if($result[1].Trim() -ne "URL reservation successfully added"){
        $failMessage = [string]::Join(".  ", ($result | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }))

        throw "Failed to run command $cmd. $failMessage"
    }

    Write-Verbose "Successfully added: $url $SecurityContext"
}