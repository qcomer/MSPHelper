function Start-DownloadFile {
    <#
    .SYNOPSIS
        Downloads a file using Powershell
    .DESCRIPTION
        Downloads a file using the provided parameters; set the download method and checks checksum (if provided)
    .PARAMETER URI
        The URI of the file to download
    .PARAMETER DownloadMethod
        The download method to use when downloading the file
    .PARAMETER Overwrite
        If true, the file will be overwritten if it already exists
    .PARAMETER FolderPath
        The folder path to download the file to.
    .PARAMETER FileName
        The name for the destination file after the file has been downloaded
    .PARAMETER Checksum
        The checksum of the file to download (provided in the format of 'Algorithm:Hash')
    .EXAMPLE
        Start-DownloadFile -URI 'https://cf-dl.datto.com/cloudcontinuity/DattoCloudContinuityInstaller.exe'
        This will download the file to c:\temp (default) and get the filename from the URI string.
    .EXAMPLE
        Start-DownloadFile -URI 'https://cf-dl.datto.com/cloudcontinuity/DattoCloudContinuityInstaller.exe' -FolderPath 'C:\Users\Public\Downloads'
        This will download the file to the specified folder and get the filename from the URI string.
    .EXAMPLE
        Start-DownloadFile -URI 'https://cf-dl.datto.com/cloudcontinuity/DattoCloudContinuityInstaller.exe' -FileName 'DattoCloudContinuityInstaller.exe'
        This will download the file to the default folder and use the specified filename.
    .EXAMPLE
        Start-DownloadFile -URI 'https://cf-dl.datto.com/cloudcontinuity/DattoCloudContinuityInstaller.exe' -Checksum 'SHA256:a0bac35619328f5f9aa56508572f343f7a388286768b31ab95377c37b052e5ac'
        This will download the file and verify the checksum. If they do not match, it will fail and exit.
    .EXAMPLE
        Start-DownloadFile -Uri 'https://cf-dl.datto.com/cloudcontinuity/DattoCloudContinuityInstaller.exe' -DownloadMethod 'WebRequest'
        This will download the file using the WebRequest method.
    #>    
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true, position = 0, ParameterSetName = 'Info')]
        [uri]
        $URI,
        [parameter(mandatory = $false, position = 2, ParameterSetName = 'Info')]
        [string]
        [ValidateSet('BITS', 'WebRequest', 'Rest', 'WebClient')]
        $DownloadMethod = 'WebRequest',
        [parameter(Mandatory = $false, Position = 3, ParameterSetName = 'Info')]
        [switch]
        $Overwrite,
        [parameter(mandatory = $false, position = 0, ParameterSetName = 'OutFolder')]
        [System.IO.DirectoryInfo]
        [ValidateScript({
                if (-not(Test-Path -Path $_)) {
                    try {
                        New-Item -ItemType -Directory -Path "$_" -Force | Out-Null
                        return $true
                    } catch {
                        return $_.Exception.message
                    }
                } }
        )]
        $FolderPath = [System.Environment]::GetEnvironmentVariable('TEMP', 'Machine'),
        [parameter(Mandatory = $false, Position = 1, ParameterSetName = 'OutFile')]
        $FileName,
        [parameter(Mandatory = $false, Position = 0, ParameterSetName = 'OutFile')]
        [ValidateScript({
                if ($_.Split(':', 2)[0] -in (Get-Command 'Microsoft.PowerShell.Utility\Get-FileHash').Parameters.Algorithm.Attributes.ValidValues) {
                    Write-Output $true
                } else {
                    Throw ('The first part ("{1}") of argument "{0}" does not belong to the set specified by Get-FileHash''s Algorithm parameter. Supply a first part "{1}" that is in the set "{2}" and then try the command again.' -f @(
                            $_
                            $_.Split(':', 2)[0]
                    ((Get-Command 'Microsoft.PowerShell.Utility\Get-FileHash').Parameters.Algorithm.Attributes.ValidValues -join ', ')
                        ))
                }
            })]
        [string]
        $Checksum
    )
    begin {
        if ($null -ne $KnownChecksum) {
            $KnownChecksum = $KnownChecksum.Trim().ToUpper()
        }
        $request = @{
            headers           = @{
                'User-Agent'   = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101 Firefox/60.0'
                'content-type' = 'application/json'
                'accept'       = 'application/json'
            }
            'Method'          = 'GET'
            'UseBasicParsing' = $true
            'URI'             = $URI
        }
        if ([System.IO.Path]::GetExtension($URI) -in @('.exe', '.msi', '.zip', '.7z')) {
            $FileName = [System.IO.Path]::GetFileName($URI)
            $FilePath = Join-Path -Path "$FolderPath" -ChildPath "$FileName"
        }
    }
    process {
        if ((Test-Path -Path "$FilePath") -and ($Overwrite -ne $true)) {
            throw "File already exists at $FilePath. Use the -Overwrite switch to overwrite the file."
        } else {
            Invoke-WebRequest @request -OutFile "$FilePath"
        }
    }        
    end {
        return $filepath
    }
}