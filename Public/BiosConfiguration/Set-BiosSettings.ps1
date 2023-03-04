function Get-DellBiosSettings {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
         $Module = Test-IsModuleInstalledandUpdated -ModuleName 'DellBiosProvider'
         if(-not($module -eq $true)){
            exit 1
         }
    }
    process {
        
    }
    
    end {
        
    }
}
function Set-DellBiosSettings {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
         $module = Test-IsModuleInstalledandUpdated -ModuleName 'DellBiosProvider'
         $module
    }
    process {
        
    }
    
    end {
        
    }
}
