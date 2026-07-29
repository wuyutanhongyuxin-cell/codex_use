param(
    [string]$TargetDir = (Join-Path $PSScriptRoot "..\runtime\sub2api"),
    [switch]$RecreateEnv
)

$ErrorActionPreference = "Stop"

$envFile = Join-Path $TargetDir ".env"
$composeFile = Join-Path $TargetDir "docker-compose.yml"

if ($RecreateEnv -or -not (Test-Path -LiteralPath $envFile) -or -not (Test-Path -LiteralPath $composeFile)) {
    & (Join-Path $PSScriptRoot "setup-sub2api.ps1") -TargetDir $TargetDir -Force:$RecreateEnv
}

Push-Location $TargetDir
try {
    docker compose up -d
    Write-Host ""
    Write-Host "Sub2API is starting."
    Write-Host "Open: http://localhost:8080"
    Write-Host "Show logs: docker compose logs -f sub2api"
} finally {
    Pop-Location
}
