param(
    [string]$TargetDir = (Join-Path $PSScriptRoot "..\runtime\sub2api")
)

$ErrorActionPreference = "Stop"

Push-Location $TargetDir
try {
    docker compose down
} finally {
    Pop-Location
}
