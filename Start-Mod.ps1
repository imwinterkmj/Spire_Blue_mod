param(
    [switch]$SkipBuild,
    [switch]$Launcher,
    [string]$MavenRepository,
    [string]$SettingsFile
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'scripts\Environment.ps1')
if (-not $SkipBuild) {
    $buildArguments = @{ Install = $true }
    if ($MavenRepository) { $buildArguments.MavenRepository = $MavenRepository }
    if ($SettingsFile) { $buildArguments.SettingsFile = $SettingsFile }
    & (Join-Path $PSScriptRoot 'Build.ps1') @buildArguments
}
$environment = Get-PrototypeEnvironment -ProjectRoot $PSScriptRoot
if ($SkipBuild) {
    Install-PrototypeJar -Environment $environment
}
$logsDir = Join-Path $PSScriptRoot 'logs'
New-Item -ItemType Directory -Path $logsDir -Force | Out-Null
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$stdout = Join-Path $logsDir "$stamp-stdout.log"
$stderr = Join-Path $logsDir "$stamp-stderr.log"
$launchArguments = @('-jar', ('"{0}"' -f $environment.Loader))
if (-not $Launcher) {
    $launchArguments += @('--mods', 'basemod,stslib,spireprototype', '--skip-intro')
}
$process = Start-Process -FilePath $environment.Java -WorkingDirectory $environment.GameDir -ArgumentList $launchArguments -WindowStyle Hidden -RedirectStandardOutput $stdout -RedirectStandardError $stderr -PassThru
[pscustomobject]@{
    ProcessId = $process.Id
    Stdout = $stdout
    Stderr = $stderr
}
