<#
.SYNOPSIS
    Smart ChatGPT CLI for PowerShell (Rev 3.1)
.DESCRIPTION
    Automatically selects the fastest available model (gpt-4o-mini if accessible),
    falls back to gpt-4o when needed, logs all responses,
    and defaults the project path to your GitHub ChatGPT-CLI folder.

.AUTHOR
    Jason Lamb (aka Jacer Racer) + ChatGPT
#>

param(
    [Parameter(Mandatory = $false)]
    [string]$Prompt = $(Read-Host "Enter your prompt"),

    [Parameter(Mandatory = $false)]
    [string]$ProjectPath
)

# --- CONFIG ---
# $githubpath = "C:\Users\user\documents\github-repos" # <-- Set your GitHub base path here
$DefaultBaseProject = Join-Path $githubpath "PowerShell-Private\ChatGPT-CLI"
if (-not $ProjectPath) { $ProjectPath = $DefaultBaseProject }

$DefaultModel  = "gpt-4o-mini"
$BackupModel   = "gpt-4o"
$ApiEndpoint   = "https://api.openai.com/v1/chat/completions"
$Key           = $env:OPENAI_API_KEY
if (-not $Key) { throw "Missing API key. Run: setx OPENAI_API_KEY 'sk-xxxx' and restart PowerShell." }

# --- MODEL AVAILABILITY PROBE ---
$ApiTestEndpoint = "https://api.openai.com/v1/models/gpt-4o-mini"
try {
    $TestResponse = Invoke-RestMethod -Uri $ApiTestEndpoint `
        -Headers @{ Authorization = "Bearer $Key" } -Method Get -ErrorAction Stop

    if ($TestResponse.id -eq "gpt-4o-mini") {
        Write-Host "✅ Model gpt-4o-mini is available. Using it as default."
        $DefaultModel = "gpt-4o-mini"
    } else {
        Write-Warning "⚠️ gpt-4o-mini not available, using gpt-4o instead."
        $DefaultModel = "gpt-4o"
    }
}
catch {
    Write-Warning "⚠️ Unable to reach or access gpt-4o-mini, defaulting to gpt-4o."
    $DefaultModel = "gpt-4o"
}

# --- LOGGING SETUP ---
$OutDir = Join-Path $ProjectPath "Project1\output"
if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir -Force | Out-Null }
$LogFile = Join-Path $OutDir ("chat-log-" + (Get-Date -Format "yyyy-MM-dd") + ".txt")

# --- LOAD REFERENCE FILES ---
$RefFolder = Join-Path $ProjectPath "Project1\reference"
$RefText = ""
if (Test-Path $RefFolder) {
    Get-ChildItem $RefFolder -File | ForEach-Object {
        $RefText += "`n### FILE: $($_.Name)`n"
        $RefText += Get-Content $_.FullName -Raw
    }
}

# --- SMART MODEL PICKER ---
$PromptLength = ($Prompt.Length + $RefText.Length)
if ($PromptLength -gt 5000) {
    $Model = $BackupModel
} else {
    $Model = $DefaultModel
}

# --- BUILD BODY ---
$Body = @{
    model = $Model
    messages = @(
        @{ role = "system"; content = "You are a PowerShell-savvy assistant. Be concise, factual, and witty if possible." },
        @{ role = "user"; content = "Reference context:`n$RefText" },
        @{ role = "user"; content = $Prompt }
    )
} | ConvertTo-Json -Depth 6

# --- MAIN REQUEST ---
try {
    $Response = Invoke-RestMethod -Uri $ApiEndpoint `
        -Headers @{ Authorization = "Bearer $Key" } `
        -Body $Body -Method Post -ContentType "application/json"
    $Result = $Response.choices[0].message.content
}
catch {
    Write-Warning "⚠️ $Model failed. Falling back to $BackupModel..."
    $Body.model = $BackupModel
    $Response = Invoke-RestMethod -Uri $ApiEndpoint `
        -Headers @{ Authorization = "Bearer $Key" } `
        -Body ($Body | ConvertTo-Json -Depth 6) -Method Post -ContentType "application/json"
    $Result = $Response.choices[0].message.content
    $Model = $BackupModel
}

# --- OUTPUT ---
Write-Host "`n🧠 Model Used : $Model"
Write-Host "💬 Response :`n"
Write-Host $Result -ForegroundColor Cyan

# --- LOG IT ---
Add-Content -Path $LogFile -Value @"
[$(Get-Date)]  Model: $Model
Prompt: $Prompt

Result:
$Result
---
"@
