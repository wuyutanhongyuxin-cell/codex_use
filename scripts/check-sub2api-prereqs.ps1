$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "Resolve-Docker.ps1")

Write-Host "Sub2API local prerequisites"
Write-Host "==========================="
Write-Host ""

$docker = Resolve-DockerCommand
if (-not $docker) {
    Write-Host "[missing] Docker command was not found."
    Write-Host ""
    Write-Host "Install Docker Desktop, then reopen PowerShell or restart Windows."
    Write-Host "Official download:"
    Write-Host "https://www.docker.com/products/docker-desktop/"
    Write-Host ""
    Write-Host "After installation, run this check again."
    exit 1
}

Write-Host "[ok] Docker command: $docker"
& $docker --version
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

& $docker compose version
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "[missing] Docker Compose is not available through Docker."
    Write-Host "Docker Desktop normally includes Docker Compose."
    exit $LASTEXITCODE
}

& $docker info | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "[not ready] Docker is installed, but this PowerShell session cannot use the Docker engine."
    Write-Host "Open Docker Desktop and wait until it says Engine running."
    Write-Host "If it already says Engine running, restart Windows once and try again."
    Write-Host ""
    Write-Host "Docker printed the original error above."
    exit $LASTEXITCODE
}

Write-Host "[ok] Docker engine is running."
Write-Host ""
Write-Host "All required local prerequisites are ready."
