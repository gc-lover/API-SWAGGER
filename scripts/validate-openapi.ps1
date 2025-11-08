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
        return @((Resolve-Path $FilePath).Path)
    }

    if ([string]::IsNullOrEmpty($DirectoryPath)) {
        return @()
    }

    $files = @()
    $files += (Get-ChildItem -Path $DirectoryPath -Filter "*.yml" -File -Recurse -ErrorAction SilentlyContinue | Sort-Object FullName | Select-Object -ExpandProperty FullName)
    $files += (Get-ChildItem -Path $DirectoryPath -Filter "*.yaml" -File -Recurse -ErrorAction SilentlyContinue | Sort-Object FullName | Select-Object -ExpandProperty FullName)

    return ($files | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Sort-Object -Unique)
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
        "*/api/v1/narrative/*" { return "narrative-service" }
        "*/api/v1/admin/*" { return "admin-service" }
        default { return "" }
    }
}

$MicroserviceRules = [ordered]@{
    "auth-service"      = @{ port = 8081; domain = "auth" }
    "character-service" = @{ port = 8082; domain = "characters" }
    "gameplay-service"  = @{ port = 8083; domain = "gameplay" }
    "social-service"    = @{ port = 8084; domain = "social" }
    "economy-service"   = @{ port = 8085; domain = "economy" }
    "world-service"     = @{ port = 8086; domain = "world" }
    "narrative-service" = @{ port = 8087; domain = "narrative" }
    "admin-service"     = @{ port = 8088; domain = "admin" }
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
                $result.metadataStatus = "missing"
                $result.errors += "Отсутствует обязательная секция info.x-microservice."
                $detected = Detect-Microservice -Path $FilePath
                if (-not [string]::IsNullOrEmpty($detected)) {
                    $result.microservice = $detected
                    $result.errors += "Предполагаемый микросервис по пути файла: $detected."
                }
            } else {
                $metadataErrors = @()
                $metadataWarnings = @()

                $properties = @($micro.PSObject.Properties.Name)

                $requiredKeys = @("name", "port", "domain", "base-path", "directory", "package")
                $missingKeys = $requiredKeys | Where-Object { $properties -notcontains $_ }
                if ($missingKeys.Count -gt 0) {
                    $metadataErrors += "info.x-microservice отсутствуют обязательные ключи: $($missingKeys -join ', ')"
                }

                $microName = if ($properties -contains "name") { $micro.name } else { $null }
                if ([string]::IsNullOrWhiteSpace($microName)) {
                    $metadataErrors += "info.x-microservice.name не должен быть пустым."
                } else {
                    $result.microservice = $microName
                    if (-not $MicroserviceRules.Contains($microName)) {
                        $metadataErrors += "Недопустимое значение info.x-microservice.name: $($microName). Разрешены: $($MicroserviceRules.Keys -join ', ')."
                    } else {
                        $expected = $MicroserviceRules[$microName]

                        if ($properties -contains "port") {
                            $rawPort = $micro.port
                            if ($null -eq $rawPort) {
                                $metadataErrors += "info.x-microservice.port должно быть целым числом."
                            } else {
                                $declaredPortValue = 0
                                if (-not [int]::TryParse($rawPort.ToString(), [ref]$declaredPortValue)) {
                                    $metadataErrors += "info.x-microservice.port должно быть целым числом."
                                } elseif ($declaredPortValue -ne $expected.port) {
                                    $metadataErrors += "Некорректный порт для $($microName): указан $declaredPortValue, ожидается $($expected.port)."
                                }
                            }
                        }

                        if ($properties -contains "domain") {
                            $declaredDomain = [string]$micro.domain
                            if ([string]::IsNullOrWhiteSpace($declaredDomain)) {
                                $metadataErrors += "info.x-microservice.domain не должен быть пустым."
                            } elseif (-not [string]::Equals($declaredDomain, $expected.domain, [System.StringComparison]::OrdinalIgnoreCase)) {
                                $metadataErrors += "Для $($microName) ожидается domain '$($expected.domain)', указано '$declaredDomain'."
                            }
                        }

                        if ($properties -contains "base-path") {
                            $basePath = [string]$micro.'base-path'
                            if ([string]::IsNullOrWhiteSpace($basePath)) {
                                $metadataErrors += "info.x-microservice.base-path не должен быть пустым."
                            } elseif (-not $basePath.StartsWith("/api/v1/$($expected.domain)", [System.StringComparison]::OrdinalIgnoreCase)) {
                                $metadataErrors += "info.x-microservice.base-path '$basePath' должен начинаться с '/api/v1/$($expected.domain)'."
                            }
                        }

                        if ($properties -contains "directory") {
                            $directoryValue = [string]$micro.directory
                            if ([string]::IsNullOrWhiteSpace($directoryValue)) {
                                $metadataErrors += "info.x-microservice.directory не должен быть пустым."
                            } else {
                                $normalizedDirectoryValue = $directoryValue.TrimEnd('/')
                                if (-not $normalizedDirectoryValue.StartsWith("api/v1/$($expected.domain)", [System.StringComparison]::OrdinalIgnoreCase)) {
                                    $metadataErrors += "info.x-microservice.directory '$directoryValue' должен начинаться с 'api/v1/$($expected.domain)'."
                                }

                                $relativePath = $result.file.Replace("\\", "/")
                                $actualDirectory = [System.IO.Path]::GetDirectoryName($relativePath)
                                if ($null -eq $actualDirectory) {
                                    $actualDirectory = ""
                                } else {
                                    $actualDirectory = $actualDirectory.Replace("\\", "/")
                                }
                                if ($actualDirectory.StartsWith("API-SWAGGER/", [System.StringComparison]::OrdinalIgnoreCase)) {
                                    $actualDirectory = $actualDirectory.Substring("API-SWAGGER/".Length)
                                }

                                if (-not [string]::Equals($actualDirectory, $normalizedDirectoryValue, [System.StringComparison]::OrdinalIgnoreCase)) {
                                    $metadataErrors += "info.x-microservice.directory '$directoryValue' не совпадает с фактическим путем '$actualDirectory'."
                                }
                            }
                        }
                    }
                }

                if ($metadataErrors.Count -gt 0) {
                    $result.metadataStatus = "invalid"
                    $result.errors += $metadataErrors
                } elseif ($metadataWarnings.Count -gt 0) {
                    $result.metadataStatus = "partial"
                    $result.warnings += $metadataWarnings
                } else {
                    $result.metadataStatus = "ok"
                }
            }
        }
    } catch {
        $result.metadataStatus = "error"
        $result.errors += "Ошибка чтения YAML: $($_.Exception.Message)"
    }

    if (-not $SkipMetadataCheck -and ($result.metadataStatus -in @("missing", "error", "invalid"))) {
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
    total         = $results.Count
    metadata_ok   = ($results | Where-Object { $_.metadataStatus -eq "ok" }).Count
    metadata_auto = ($results | Where-Object { $_.metadataStatus -eq "detected" }).Count
    metadata_warn = ($results | Where-Object { $_.metadataStatus -eq "partial" }).Count
    metadata_err  = ($results | Where-Object { $_.metadataStatus -in @("missing", "error", "invalid") }).Count
    validation_ok = ($results | Where-Object { $_.validationStatus -eq "passed" }).Count
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

