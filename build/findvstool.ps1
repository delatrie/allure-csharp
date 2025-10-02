[CmdletBinding()]
Param
(
    [Parameter(Mandatory = $True)]
    [string] $ToolName
)

$DEFAULT_VSWHERE_PATH = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"

If (-not $IsWindows)
{
    Throw "Can't run this script on $($PSVersionTable.Platform). Windows is required"
}

$VsWhere = ("vswhere.exe", $DEFAULT_VSWHERE_PATH) | ForEach-Object {
    Get-Command -CommandType Application -ErrorAction SilentlyContinue $_
} | Select-Object -first 1

If (-not $VsWhere)
{
    Throw "vswhere.exe needs to be in PATH or at '$DEFAULT_VSWHERE_PATH'"
}

$VsInstallPath = & $VsWhere -latest -property installationPath
If (-not $VsInstallPath)
{
    Throw "Can't resolve a Visual Studio installation path. vswhere.exe exited with code $LASTEXITCODE"
}

$LaunchDevToolPath = Join-Path $VsInstallPath 'Common7\Tools\Launch-VsDevShell.ps1'

if (-not (Test-Path -PathType Leaf $LaunchDevToolPath))
{
    Throw "Can't find the Developer PowerShell launch script at '$LaunchDevToolPath'"
}

$Cwd = Get-Location

& $LaunchDevToolPath | Out-Null

Set-Location $Cwd

$Tool = Get-Command -CommandType Application -ErrorAction SilentlyContinue $ToolName
If (-not $Tool)
{
    Throw "Can't find $ToolName"
}

$Tool.Source
