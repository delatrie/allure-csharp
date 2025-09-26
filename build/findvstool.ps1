[CmdletBinding()]
Param ([string] $ToolName)

If (-not $IsWindows)
{
    Write-Error "Can't run this script on $($PSVersionTable.Platform). Windows is required"
    Return
}

$VsInstallPath = vswhere.exe -latest -property installationPath
$LaunchDevToolPath = Join-Path $VsInstallPath 'Common7\Tools\Launch-VsDevShell.ps1'

if (-not (Test-Path -PathType Leaf $LaunchDevToolPath))
{
    Write-Error "Can't find the Developer PowerShell launch script at '$LaunchDevToolPath'"
    Return
}

& $LaunchDevToolPath | Out-Null
If (-not $?)
{
    Return
}

$ToolPath = (Get-Command -CommandType Application -ErrorAction SilentlyContinue $ToolName).Source
If (-not $ToolPath)
{
    Write-Error "Can't find $ToolName"
    Return
}

$ToolPath
