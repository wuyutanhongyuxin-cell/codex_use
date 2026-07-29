$ErrorActionPreference = "Stop"

Write-Host "Sub2API local prerequisites"
Write-Host "==========================="
Write-Host ""

$docker = Get-Command docker -ErrorAction SilentlyContinue
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

Write-Host "[ok] Docker command: $($docker.Source)"
docker --version

try {
    docker compose version
} catch {
    Write-Host ""
    Write-Host "[missing] Docker Compose is not available through Docker."
    Write-Host "Docker Desktop normally includes Docker Compose."
    exit 1
}

try {
    docker info | Out-Null
    Write-Host "[ok] Docker engine is running."
} catch {
    Write-Host ""
    Write-Host "[not running] Docker is installed, but the Docker engine is not running."
    Write-Host "Open Docker Desktop and wait until it says it is running, then try again."
    exit 1
}

Write-Host ""
Write-Host "All required local prerequisites are ready."
