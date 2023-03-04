function Get-LogDatetime {
    begin {
        $LogFileStamp = '{0:yyyyMMdd}{0:HHmmz}' -f (Get-Date)
    }
    process {
        if ([string]::IsNullOrEmpty($LogFileStamp)) {
            Write-Output 'ERROR: Unable to get Log File Time Stamp'
            exit 1
        }
    }
    end {
        $script:DateTimeSet = $true
        return $LogFileStamp
    }
}

function Write-LogEntry {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]
        $LogName,
        [Parameter(Position = 1)]
        [System.IO.FileInfo]$FolderPath = [System.Environment]::GetEnvironmentVariable('TEMP', 'Machine'),
        [Parameter(Mandatory = $true, ValueFromPipeline, Position = 2)]
        [string]
        $Message,
        [Parameter(Position = 3)]
        [ValidateSet('Info', 'Warning', 'Error', 'Success')]
        [string]
        $MessageType
    )
    begin {
        $DatetimeStamp = Get-LogDatetime
        if ([string]::ISNullOrEmpty($LogFileFullName)) {
            $script:LogFileFullName = -join @(
                "$LogName"
                '_'
                "$DatetimeStamp"
                '.log'
            )
        }
        $LogFilePath = Join-Path -Path "$FolderPath" -ChildPath "$LogFileFullName"
        if (-not(Test-Path -Path $LogFilePath)) {
            New-Item -Path $LogFilePath -ItemType File -Force | Out-Null
        }
    }
    process {
        $TimeStamp = "$('[{0:MM/dd/yy} {0:HH:mm:ss}]' -f (Get-Date))"
        Add-Content -Path "$LogFilePath" -Value "$TimeStamp - ${MessageType}: $Message" -Force | Out-Null
    }
    end {
        Write-Verbose "$Timestamp - ${MessageType}: $Message"
    }
}

function Start-LogFile {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true, ValueFromPipeline, Position = 0)]
        [string]
        $LogName
    )
    begin {
        $Start = '{0:MM/dd/yyyy} {0:HH:mm:ss UTCz}' -f (Get-Date)
        $Messages = New-Object System.Collections.Generic.List[System.Object]
        $Messages.Add('*****************************************************')
        if (-not([string]::ISNullOrEmpty($ScriptInvocation.MyCommand.Name))) {
            [string]$ScriptName = "$($ScriptInvocation.MyCommand.Name)"
            $Messages.Add("Script Name: $ScriptName")
        } else {
            $Messages.Add("Script Start Time: $Start")
        }
        $Messages.Add('*****************************************************')
        $Messages = $Messages.ToArray()
    }
    process {
        $Messages | ForEach-Object { Write-LogEntry -Message "$_" -LogName "$LogName" }
    }
    end {
        return $true
    }
}
function End-LogFile {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true, ValueFromPipeline, Position = 0)]
        [string]
        $LogName
    )
    begin {
        $End = '{0:MM/dd/yyyy} {0:HH:mm:ss UTCz}' -f (Get-Date)
        $Messages = New-Object System.Collections.Generic.List[System.Object]
        $Messages.Add('*****************************************************')
        $Messages.Add("Script End Time: $End")
        $Messages.Add('*****************************************************')
        $Messages = $Messages.ToArray()
    }
    process {
        $Messages | ForEach-Object { Write-LogEntry -Message "$_" -LogName "$LogName" }
    }
    end {
        return $true
    }
}