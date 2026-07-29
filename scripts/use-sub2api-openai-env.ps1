param(
    [Parameter(Mandatory = $true)]
    [string]$ApiKey,
    [string]$BaseUrl = "http://localhost:8080/openai/v1"
)

$env:OPENAI_API_KEY = $ApiKey
$env:OPENAI_BASE_URL = $BaseUrl

Write-Host "Set current PowerShell session:"
Write-Host "  OPENAI_API_KEY=<hidden>"
Write-Host "  OPENAI_BASE_URL=$BaseUrl"
Write-Host ""
Write-Host "Use an API key generated in the Sub2API admin UI."
