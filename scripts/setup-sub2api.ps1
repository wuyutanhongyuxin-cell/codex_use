param(
    [string]$SourceDeployDir = (Join-Path $PSScriptRoot "..\sub2api\deploy"),
    [string]$TargetDir = (Join-Path $PSScriptRoot "..\runtime\sub2api"),
    [int]$Port = 8080,
    [string]$AdminEmail = "admin@sub2api.local",
    [switch]$Force
)

$ErrorActionPreference = "Stop"

function New-HexSecret {
    param([int]$Bytes = 32)
    $buffer = New-Object byte[] $Bytes
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    try {
        $rng.GetBytes($buffer)
    } finally {
        $rng.Dispose()
    }
    return ([BitConverter]::ToString($buffer) -replace "-", "").ToLowerInvariant()
}

$sourceComposeLocal = Join-Path $SourceDeployDir "docker-compose.local.yml"
$sourceComposeDefault = Join-Path $SourceDeployDir "docker-compose.yml"
$sourceEnv = Join-Path $SourceDeployDir ".env.example"

if (-not (Test-Path -LiteralPath $sourceEnv)) {
    throw "Cannot find Sub2API .env.example at: $sourceEnv"
}

if (Test-Path -LiteralPath $sourceComposeLocal) {
    $sourceCompose = $sourceComposeLocal
} elseif (Test-Path -LiteralPath $sourceComposeDefault) {
    $sourceCompose = $sourceComposeDefault
} else {
    throw "Cannot find Sub2API docker compose file under: $SourceDeployDir"
}

New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null

$targetCompose = Join-Path $TargetDir "docker-compose.yml"
$targetEnv = Join-Path $TargetDir ".env"

if ((Test-Path -LiteralPath $targetEnv) -and -not $Force) {
    Write-Host "Existing .env found: $targetEnv"
    Write-Host "Use -Force to regenerate it."
    exit 0
}

Copy-Item -LiteralPath $sourceCompose -Destination $targetCompose -Force

$envText = Get-Content -LiteralPath $sourceEnv -Raw -Encoding UTF8
$envText = $envText -replace "(?m)^SERVER_PORT=.*$", "SERVER_PORT=$Port"
$envText = $envText -replace "(?m)^POSTGRES_PASSWORD=.*$", "POSTGRES_PASSWORD=$(New-HexSecret 24)"
$envText = $envText -replace "(?m)^ADMIN_EMAIL=.*$", "ADMIN_EMAIL=$AdminEmail"
$envText = $envText -replace "(?m)^ADMIN_PASSWORD=.*$", "ADMIN_PASSWORD=$(New-HexSecret 18)"
$envText = $envText -replace "(?m)^JWT_SECRET=.*$", "JWT_SECRET=$(New-HexSecret 32)"
$envText = $envText -replace "(?m)^TOTP_ENCRYPTION_KEY=.*$", "TOTP_ENCRYPTION_KEY=$(New-HexSecret 32)"

Set-Content -LiteralPath $targetEnv -Value $envText -Encoding UTF8

Write-Host "Prepared Sub2API runtime files:"
Write-Host "  $targetCompose"
Write-Host "  $targetEnv"
Write-Host "Service URL after start: http://localhost:$Port"
