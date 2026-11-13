param(
    [switch]$Install,
    [string]$MavenRepository,
    [string]$SettingsFile
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'scripts\Environment.ps1')
$environment = Get-PrototypeEnvironment -ProjectRoot $PSScriptRoot
$maven = Get-Command mvn -ErrorAction Stop
$mavenArguments = @(
    '-B',
    '-ntp',
    '-f', (Join-Path $PSScriptRoot 'pom.xml'),
    "-Dsteam.windows=$($environment.SteamApps.Replace('\', '/'))",
    '-Dmaven.test.skip=true'
)
if ($MavenRepository) {
    $mavenArguments += "-Dmaven.repo.local=$([IO.Path]::GetFullPath($MavenRepository))"
}
if ($SettingsFile) {
    $settingsPath = [IO.Path]::GetFullPath($SettingsFile)
    $mavenArguments += @('-s', $settingsPath, '-gs', $settingsPath)
}
$mavenArguments += 'package'

Push-Location -LiteralPath $PSScriptRoot
try {
    & $maven.Source @mavenArguments
    if ($LASTEXITCODE -ne 0) {
        throw "Maven failed with exit code $LASTEXITCODE"
    }
} finally {
    Pop-Location
}
if (-not (Test-Path -LiteralPath $environment.Jar -PathType Leaf)) {
    throw 'Maven completed without producing the expected JAR.'
}
Write-Host "Built: $($environment.Jar)"
if ($Install) {
    Install-PrototypeJar -Environment $environment
}
