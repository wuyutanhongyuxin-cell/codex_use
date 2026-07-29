param(
    [string]$TargetDir = (Join-Path $PSScriptRoot "..\runtime\sub2api"),
    [switch]$RecreateEnv
)

$ErrorActionPreference = "Stop"

$envFile = Join-Path $TargetDir ".env"
$composeFile = Join-Path $TargetDir "docker-compose.yml"

$docker = Get-Command docker -ErrorAction SilentlyContinue
if (-not $docker) {
    Write-Host "Docker command was not found."
    Write-Host ""
    Write-Host "Install Docker Desktop first:"
    Write-Host "https://www.docker.com/products/docker-desktop/"
    Write-Host ""
    Write-Host "Then reopen PowerShell or restart Windows and click Start again."
    exit 1
}

try {
    docker info | Out-Null
} catch {
    Write-Host "Docker is installed, but the Docker engine is not running."
    Write-Host ""
    Write-Host "Open Docker Desktop and wait until it finishes starting, then click Start again."
    exit 1
}

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
