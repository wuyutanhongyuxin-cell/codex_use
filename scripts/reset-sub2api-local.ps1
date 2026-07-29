param(
    [string]$TargetDir = (Join-Path $PSScriptRoot "..\runtime\sub2api")
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "Resolve-Docker.ps1")

$docker = Resolve-DockerCommand
if (-not $docker) {
    throw "Docker command was not found."
}

if (Test-Path -LiteralPath $TargetDir) {
    Push-Location $TargetDir
    try {
        & $docker compose down -v
        if ($LASTEXITCODE -ne 0) {
            exit $LASTEXITCODE
        }
    } finally {
        Pop-Location
    }
}

& (Join-Path $PSScriptRoot "setup-sub2api.ps1") -TargetDir $TargetDir -Force
& (Join-Path $PSScriptRoot "start-sub2api.ps1") -TargetDir $TargetDir
