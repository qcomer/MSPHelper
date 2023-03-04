function Test-IsModuleInstalledandUpdated {
    <#
    .SYNOPSIS
        Checks to see if a module is installed and up-to-date.
    .DESCRIPTION
        Checks to see if the provided module name(s) are installed and up-to-date.
    .NOTES
        N/A
    .PARAMETER ModuleName
        (Required) The name of the module to test (and update).
    .PARAMETER DoNotUpdate
        (Optional) If specified, the module will not be updated if it is not the latest version.
    .PARAMETER DoNotInstall
        (Optional) If specified, the module will not be installed if it is not installed.
    .INPUTS
        [String] (ModuleName). Specifies the Module Name. Accepts pipeline input.
    .INPUTS
        [Switch] (DoNotUpdate). Specifies that the module should not be updated if it is not the latest version.
    .INPUTS
        [Switch] (DoNotInstall). Specifies that the module should not be installed if it is not installed.
    .OUTPUTS
        [Boolean] (True or False). Returns true if the module conditions meet the parameters.
    .OUTPUTS
        [String] (Verbose). Returns a verbose message detailing the status of the module.
    .EXAMPLE
        PS> Test-ModuleInstalled -ModuleName 'ActiveDirectory'
        Returns true or false if the ActiveDirectory module is installed and up-to-date.
    .EXAMPLE
        PS> Test-ModuleInstalled -ModuleName 'ActiveDirectory' -DoNotUpdate
        Returns true or false if the ActiveDirectory module is installed regardless of version.
    .EXAMPLE
        PS> Test-ModuleInstalled -ModuleName 'ActiveDirectory' -DoNotInstall
        Returns true or false if the ActiveDirectory module is installed. Does not install if not installed.
    .EXAMPLE
        PS> Test-ModuleInstalled -ModuleName 'ActiveDirectory' -DoNotUpdate -DoNotInstall
        Returns true or false if the ActiveDirectory module is installed regardless of version. Does not install if not installed.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline, Position = 0)]
        [String]
        $ModuleName,
        [Parameter(Mandatory = $false, Position = 1)]
        [switch]
        $DoNotUpdate = $false,
        [Parameter(Mandatory = $false , Position = 2)]
        $DoNotInstall = $false
    )
    begin {
        $ErrorActionPreference = 'Stop'
        try {
            $Module = Get-Module -ListAvailable -Name "$ModuleName"
            $InstalledVersion = $Module.Version -as [version]
        } catch {
            $module = $null
        }
        try {
            $OnlineModule = Find-Module -Name "$ModuleName"
            $onlineVersion = $OnlineModule.Version -as [version]
        } catch {
            $OnlineModule = $null
        }
        $return = $true
    }  
    process {
        if ([string]::IsNullOrEmpty($Module) -and $null -ne $OnlineModule) {
            try {
                Install-Module -Name "$ModuleName" -Force
            } catch {
                $Verbose = "ERROR: Failed to install module $moduleName. Result: $($_.exception.message)"
                $return = $false
            }
        } elseif ($onlineVersion -gt $InstalledVersion) {
            try {
                Update-Module -Name "$ModuleName" -Force
            } catch {
                $Verbose = "ERROR: Failed to update module $moduleName. Result: $($_.exception.message)"
                $return = $false
            }
        } elseif ($InstalledVersion -eq $OnlineModule) {
            $Verbose = "SUCCESS: Module $ModuleName is up-to-date."
        } elseif ($null -ne $Module -and $null -eq $OnlineModule) {
            $Verbose = 'WARNING: Installed module could not be found in repository online. assuming latest version'
        } else {
            $Verbose = "ERROR: Unable to determine any status for module $ModuleName."
            $return = $false
        }
    }
    end {
        Write-Verbose "$Verbose"
        return $return
        
    }
}