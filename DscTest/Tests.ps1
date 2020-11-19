BeforeAll {
    . $PSScriptRoot\..\Module\Get-UrlAcl.ps1
    . $PSScriptRoot\..\Module\Remove-UrlAcl.ps1
}

Describe "Remove-UrlAcl" {
    It "removes acl" {
        New-UrlAcl -Protocol http -HostName + -Port 69 -SecurityContext Everyone
        
        $acl = Get-UrlAcl -Protocol http -HostName + -Port 69 

        $acl | Should -Not -BeNull

        $acl | Remove-UrlAcl 

        $acl = Get-UrlAcl -Protocol http -HostName + -Port 69 
        
        $acl | Should -BeNull
    }
    It "removes multiple acls" {
        New-UrlAcl -Protocol http -HostName + -Port 69 -SecurityContext Everyone
        New-UrlAcl -Protocol http -HostName + -Port 69 -Path SomeSubPath -SecurityContext Everyone
        
        $acls = Get-UrlAcl -Protocol http -HostName + -Port 69 

        $acls | Should -Not -BeNull
        $acls.Count | Should -BeExactly 2

        $acls | Remove-UrlAcl 

        $acls = Get-UrlAcl -Protocol http -HostName + -Port 69 
        
        $acls | Should -BeNull
    }
}