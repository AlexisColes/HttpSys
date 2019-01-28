Function Remove-UrlAcl {
    [CmdletBinding()] 
    Param( 
        [Parameter(Position=0, ValueFromPipeline=$true)]
        [UrlAcl[]]$UrlAcl
    )

    if($UrlAcl -isnot [System.Array]){
        $UrlAcl = @($UrlAcl)
    }

    $baseCmd = "netsh http delete urlacl"

    foreach($acl in $UrlAcl){
        $deleteCmd = "$baseCmd url=$($acl.Url)"

        $result = Invoke-Expression $deleteCmd

        if($result[1].Trim() -ne "URL reservation successfully deleted"){
            $failMessage = [string]::Join(".  ", ($resultFailed | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }))

            throw "Failed to run command $deleteCmd. $failMessage"
        }

        Write-Verbose "Successfully deleted: $($acl.Url)"
    }
}