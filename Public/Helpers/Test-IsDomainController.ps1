function Test-IsDomainController {
    <#
    .SYNOPSIS
        Tests to see if the object is a Domain Controller
    .DESCRIPTION
        This function will test if the target computer (or local computer) is a domain controller and return $true of $false in a boolean format.
    .NOTES
    .PARAMETER ComputerName
        (Optional) The computer name to test. If not specified, the local computer will be tested.
    .INPUTS
        [String] (ComputerName). Can be used to specify a remote computer. Accepts pipeline input.
    .OUTPUTS
        [Boolean] (True or False). Returns true if the computer is a domain controller, false if not.
    .EXAMPLE
        PS> Test-IsDomainController
        Returns true or false if the local computer is a domain controller
    .EXAMPLE
        PS> Test-IsDomainController -ComputerName DC01
        Returns true or false if the DC01 computer is a domain controller
    .EXAMPLE
        PS> Get-ADComputer -Filter * | Test-IsDomainController
        Returns true or false if the computer is a domain controller
    #>
    [OutputType([Bool])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline, Position = 0)]
        [string]
        $ComputerName = $env:computername
    )
    begin {
        $IsDCCheck = Get-CimInstance -ClassName Win32_OperatingSystem

        if (-not([string]::IsNullOrEmpty($ComputerName))) {
            $IsDCCheck = "$IsDCCheck -ComputerName $ComputerName"
        }
    }
    process {
        if (-not(($IsDCCheck).PropertyType -eq 2)) {
            $return = $false
        }
        $return = $true
    }
    end {
        return $return
    }
}