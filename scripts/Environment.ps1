function Get-PrototypeEnvironment {
    param([Parameter(Mandatory = $true)][string]$ProjectRoot)

    $settingsPath = Join-Path $ProjectRoot 'local.settings.json'
    if (-not (Test-Path -LiteralPath $settingsPath)) {
        throw 'Missing local.settings.json. Set steamApps to the Steam library steamapps directory.'
    }
    $settings = Get-Content -LiteralPath $settingsPath -Raw | ConvertFrom-Json
    $steamApps = [IO.Path]::GetFullPath($settings.steamApps)
    $gameDir = Join-Path $steamApps 'common\SlayTheSpire'
    $environment = [pscustomobject]@{
        SteamApps = $steamApps
        GameDir = $gameDir
        GameJar = Join-Path $gameDir 'desktop-1.0.jar'
        Java = Join-Path $gameDir 'jre\bin\javaw.exe'
        Loader = Join-Path $steamApps 'workshop\content\646570\1605060445\ModTheSpire.jar'
        BaseMod = Join-Path $steamApps 'workshop\content\646570\1605833019\BaseMod.jar'
        StSLib = Join-Path $steamApps 'workshop\content\646570\1609158507\StSLib.jar'
        Jar = Join-Path $ProjectRoot 'target\spireprototype.jar'
        ModsDir = Join-Path $gameDir 'mods'
    }
    foreach ($property in @('GameJar', 'Java', 'Loader', 'BaseMod', 'StSLib')) {
        $path = $environment.$property
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
            throw "Required file missing: $path"
        }
    }
    return $environment
}

function Install-PrototypeJar {
    param([Parameter(Mandatory = $true)]$Environment)

    if (-not (Test-Path -LiteralPath $Environment.Jar -PathType Leaf)) {
        throw 'Build the project first: .\Build.ps1'
    }
    New-Item -ItemType Directory -Path $Environment.ModsDir -Force | Out-Null
    $destination = Join-Path $Environment.ModsDir 'spireprototype.jar'
    Copy-Item -LiteralPath $Environment.Jar -Destination $destination -Force
    Write-Host "Installed: $destination"
}
