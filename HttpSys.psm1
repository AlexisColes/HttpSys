gci $psscriptroot\*.ps1 -Recurse | % {. $_.FullName }
Export-ModuleMember -Alias * -Function * -Cmdlet *