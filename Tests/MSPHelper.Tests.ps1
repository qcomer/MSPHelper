Describe 'MSPHelper Tests' {

    BeforeAll {
        Import-Module "MSPHelper" -ea 0 -Force
        $script:thisModule = Get-Module -Name "MSPHelper"
        $script:funcNames = $thisModule.ExportedCommands.Values |
            Where-Object {$_.CommandType -eq 'Function'} |
            Select-Object -ExpandProperty Name

        # dot-sourcing all functions: Required for Mocking
        $modParent = Split-Path $thisModule.Path -Parent
        Get-ChildItem   $modParent\Private\*.ps1,
                        $modParent\Public\*.ps1   |
        ForEach-Object {. $_.FullName}
    }

    Context 'Test Module import' {

        It 'Ensures module is imported' {
            $script:thisModule.Name | Should -Be 'MSPHelper'
        }

    }

    Context 'Test MSPHelper Functions' {

        # Remove the tested item from the initial array
        AfterEach {
            $script:funcNames = $script:funcNames | Where-Object {$_ -ne $script:thisName}
        }

        It 'Valid Value (sample test)' {
            $Valid = 'Get-Valid'
            $Valid | Should -Be $Valid

            $script:thisName = 'Get-Valid'
        }

    }

    Context 'Clean up' {

        It 'Ensures all public functions have tests' {
            $script:funcNames | Should -BeNullOrEmpty
        }
        
    }

}

