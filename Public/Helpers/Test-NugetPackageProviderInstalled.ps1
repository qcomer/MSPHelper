function Test-NugetPackageProviderInstalled {
    <#
    .SYNOPSIS
        Tests to see if Nuget Package Provider is Installed and the proper version.
    .DESCRIPTION
        A longer description of the function, its purpose, common use cases, etc.
    .NOTES
        Information or caveats about the function e.g. 'This function is not supported in Linux'
    .LINK
        Specify a URI to a help page, this will show when Get-Help -Online is used.
    .PARAMETER minimumVersion
        The minimum version of the Nuget Package Provider that is required.
    .EXAMPLE
        Test-MyTestFunction -Verbose
        Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
    #>
    
    
    [CmdletBinding()]
    param (
        [version]
        $minimumVersion = 2.8.5.201
        
    )
    
    begin {
        $ErrorActionPreference = 'Stop'
        try{
            Get-PackageProvider -ListAvailable -Name 'Nuget' | Where-Object { $_.Version -ge $minimumVersion }
        }catch {

        }
        
    }
    
    process {
        
    }
    
    end {
        
    }
}