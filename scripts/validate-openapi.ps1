#!/usr/bin/env pwsh
param(
    [string]$ApiSpec = "",
    [string]$ApiDirectory = "",
    [switch]$CheckMetadataOnly,
    [switch]$SkipMetadataCheck,
    [switch]$Parallel,
    [string]$ReportFile = ""
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepositoryRoot = Split-Path -Parent $ScriptDir
Set-Location $RepositoryRoot

if ([string]::IsNullOrEmpty($ApiSpec) -and [string]::IsNullOrEmpty($ApiDirectory)) {
    throw "Укажите -ApiSpec или -ApiDirectory."
}

if (-not [string]::IsNullOrEmpty($ApiSpec) -and -not (Test-Path $ApiSpec)) {
    throw "Файл не найден: $ApiSpec"
}

if (-not [string]::IsNullOrEmpty($ApiDirectory) -and -not (Test-Path $ApiDirectory)) {
    throw "Директория не найдена: $ApiDirectory"
}

if ([string]::IsNullOrEmpty($ReportFile)) {
    $ReportFile = Join-Path $ScriptDir "validation-report.json"
}

function Get-ApiFiles {
    param([string]$FilePath, [string]$DirectoryPath)
    if (-not [string]::IsNullOrEmpty($FilePath)) {
        return @(Resolve-Path $FilePath)
    }
    Get-ChildItem -Path $DirectoryPath -Filter "*.yml" -File -Recurse |
        Sort-Object FullName |
        ForEach-Object { $_.FullName } +
    (Get-ChildItem -Path $DirectoryPath -Filter "*.yaml" -File -Recurse |
        Sort-Object FullName |
        ForEach-Object { $_.FullName })
}

function Detect-Microservice {
    param([string]$Path)
    $normalized = $Path.Replace("\", "/").ToLowerInvariant()
    switch -Wildcard ($normalized) {
        "*/api/v1/auth/*" { return "auth-service" }
        "*/api/v1/characters/*" { return "character-service" }
        "*/api/v1/players/*" { return "character-service" }
        "*/api/v1/gameplay/*" { return "gameplay-service" }
        "*/api/v1/social/*" { return "social-service" }
        "*/api/v1/economy/*" { return "economy-service" }
        "*/api/v1/inventory/*" { return "economy-service" }
        "*/api/v1/trade/*" { return "economy-service" }
        "*/api/v1/world/*" { return "world-service" }
        "*/api/v1/locations/*" { return "world-service" }
        default { return "" }
    }
}

function Validate-File {
    param([string]$FilePath)
    $result = [ordered]@{
        file             = [IO.Path]::GetRelativePath($RepositoryRoot, $FilePath)
        microservice     = $null
        metadataStatus   = "unknown"
        validationStatus = "skipped"
        errors           = @()
        warnings         = @()
    }

    try {
        $yamlContent = Get-Content -Path $FilePath -Raw
        $parsed = $yamlContent | ConvertFrom-Yaml -ErrorAction Stop
        if ($null -eq $parsed.info) {
            $result.metadataStatus = "missing"
            $result.errors += "Отсутствует секция info."
        } else {
            $micro = $parsed.info."x-microservice"
            if ($null -eq $micro) {
                $detected = Detect-Microservice -Path $FilePath
                if ([string]::IsNullOrEmpty($detected)) {
                    $result.metadataStatus = "missing"
                    $result.errors += "Не обнаружена секция info.x-microservice и не удалось определить микроcервис по пути."
                } else {
                    $result.metadataStatus = "detected"
                    $result.microservice = $detected
                    $result.warnings += "info.x-microservice отсутствует, автоматически определено: $detected"
                }
            } else {
                $requiredKeys = @("name", "port", "domain", "base-path", "package")
                $missingKeys = $requiredKeys | Where-Object { -not $micro.PSObject.Properties.Name.Contains($_) }
                if ($missingKeys.Count -gt 0) {
                    $result.metadataStatus = "partial"
                    $result.warnings += "info.x-microservice отсутствуют ключи: $($missingKeys -join ', ')"
                } else {
                    $result.metadataStatus = "ok"
                }
                $result.microservice = $micro.name
            }
        }
    } catch {
        $result.metadataStatus = "error"
        $result.errors += "Ошибка чтения YAML: $($_.Exception.Message)"
    }

    if (-not $SkipMetadataCheck -and ($result.metadataStatus -eq "missing" -or $result.metadataStatus -eq "error")) {
        return $result
    }

    if (-not $CheckMetadataOnly) {
        $validationOutput = & npx --yes swagger-cli validate $FilePath 2>&1
        if ($LASTEXITCODE -eq 0) {
            $result.validationStatus = "passed"
        } else {
            $result.validationStatus = "failed"
            $result.errors += ($validationOutput -join "`n")
        }
    }

    return $result
}

$apiFiles = Get-ApiFiles -FilePath $ApiSpec -DirectoryPath $ApiDirectory
if ($apiFiles.Count -eq 0) {
    throw "Не найдено OpenAPI файлов."
}

Write-Host "Проверяется файлов: $($apiFiles.Count)"

$results = @()

if ($Parallel) {
    $results = $apiFiles | ForEach-Object -Parallel {
        Set-Location $using:RepositoryRoot
        Validate-File -FilePath $_
    }
} else {
    foreach ($file in $apiFiles) {
        Write-Host "→ $([IO.Path]::GetRelativePath($RepositoryRoot, $file))"
        $results += Validate-File -FilePath $file
    }
}

$summary = [ordered]@{
    total        = $results.Count
    metadata_ok  = ($results | Where-Object { $_.metadataStatus -eq "ok" }).Count
    metadata_auto= ($results | Where-Object { $_.metadataStatus -eq "detected" }).Count
    metadata_warn= ($results | Where-Object { $_.metadataStatus -eq "partial" }).Count
    metadata_err = ($results | Where-Object { $_.metadataStatus -in @("missing", "error") }).Count
    validation_ok= ($results | Where-Object { $_.validationStatus -eq "passed" }).Count
    validation_err= ($results | Where-Object { $_.validationStatus -eq "failed" }).Count
}

$report = [ordered]@{
    generatedAt = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    repository  = $RepositoryRoot
    summary     = $summary
    results     = $results
}

$report | ConvertTo-Json -Depth 6 | Set-Content -Path $ReportFile -Encoding UTF8

Write-Host "`nИтоги:"
Write-Host "  Метаданные (ok/auto/warn/err): $($summary.metadata_ok)/$($summary.metadata_auto)/$($summary.metadata_warn)/$($summary.metadata_err)"
Write-Host "  Валидация (ok/err): $($summary.validation_ok)/$($summary.validation_err)"
Write-Host "  Отчет: $ReportFile"

$exitCode = if ($summary.metadata_err -gt 0 -or $summary.validation_err -gt 0) { 1 } else { 0 }
exit $exitCode

