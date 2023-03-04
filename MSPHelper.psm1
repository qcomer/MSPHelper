$Public = Get-ChildItem "$PSScriptRoot\Public\*.ps1" -Recurse
#$Private = Get-ChildItem "$PSScriptRoot\Private\*.ps1" -Recurse
if ($Public.Count -gt 0) {
    Foreach ($File in $Public) {
        try {
            . $File.FullName -Force
        } catch {
            Write-Error "Failed to import $($File.FullName): $($_.Exception)."
        }
    }
}
Export-ModuleMember -Function * -Alias * -Variable *