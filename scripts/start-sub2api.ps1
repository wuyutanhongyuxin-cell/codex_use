param(
    [string]$TargetDir = (Join-Path $PSScriptRoot "..\runtime\sub2api"),
    [switch]$RecreateEnv
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "Resolve-Docker.ps1")

$envFile = Join-Path $TargetDir ".env"
$composeFile = Join-Path $TargetDir "docker-compose.yml"

$docker = Resolve-DockerCommand
if (-not $docker) {
    Write-Host "Docker command was not found."
    Write-Host ""
    Write-Host "Install Docker Desktop first:"
    Write-Host "https://www.docker.com/products/docker-desktop/"
    Write-Host ""
    Write-Host "Then reopen PowerShell or restart Windows and click Start again."
    exit 1
}

& $docker info | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker is installed, but this PowerShell session cannot use the Docker engine."
    Write-Host ""
    Write-Host "Open Docker Desktop and wait until it finishes starting."
    Write-Host "If Docker Desktop already says Engine running, restart Windows once and try again."
    Write-Host ""
    Write-Host "Docker printed the original error above."
    exit $LASTEXITCODE
}

if ($RecreateEnv -or -not (Test-Path -LiteralPath $envFile) -or -not (Test-Path -LiteralPath $composeFile)) {
    & (Join-Path $PSScriptRoot "setup-sub2api.ps1") -TargetDir $TargetDir -Force:$RecreateEnv
}

Push-Location $TargetDir
try {
    & $docker compose up -d
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
    Write-Host ""
    Write-Host "Sub2API is starting."
    Write-Host "Open: http://localhost:8080"
    Write-Host "Show logs: docker compose logs -f sub2api"
} finally {
    Pop-Location
}
