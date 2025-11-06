# Add Architecture Comments to OpenAPI Files
# Добавляет комментарии о целевой архитектуре в OpenAPI спецификации

param(
    [string]$RootPath = "api\v1",
    [switch]$DryRun = $false,
    [switch]$Verbose = $false
)

# Функция для определения микросервиса по API path
function Get-Microservice {
    param([string]$Path)
    
    $path = $Path.Replace('\', '/')
    
    # API path mapping to microservice
    if ($path -match "/auth/") { return @{Name="auth-service"; Port=8081} }
    if ($path -match "/characters/") { return @{Name="character-service"; Port=8082} }
    if ($path -match "/gameplay/combat/") { return @{Name="gameplay-service"; Port=8083} }
    if ($path -match "/gameplay/progression/") { return @{Name="gameplay-service"; Port=8083} }
    if ($path -match "/gameplay/social/|/social/") { return @{Name="social-service"; Port=8084} }
    if ($path -match "/gameplay/economy/") { return @{Name="economy-service"; Port=8085} }
    if ($path -match "/gameplay/world/|/locations/") { return @{Name="world-service"; Port=8086} }
    if ($path -match "/lore/") { return @{Name="world-service"; Port=8086} }
    if ($path -match "/narrative/|/quests/") { return @{Name="narrative-service"; Port=8087} }
    if ($path -match "/admin/") { return @{Name="admin-service"; Port=8088} }
    if ($path -match "/gameplay/") { return @{Name="gameplay-service"; Port=8083} }
    
    # Default
    return @{Name="gameplay-service"; Port=8083}
}

# Функция для определения фронтенд-модуля по категории
function Get-FrontendModule {
    param([string]$Path)
    
    $path = $Path.Replace('\', '/')
    
    # Category mapping to frontend module
    if ($path -match "/gameplay/social/|/social/") {
        return @{
            Module="modules/social"
            Store="useSocialStore"
            UIComponents="PersonalNpcCard, FriendCard, GuildCard"
            Forms="NpcInteractionForm, GuildForm"
            State="friends, guilds, personalNpcs"
        }
    }
    if ($path -match "/gameplay/economy/|/trade/|/trading/") {
        return @{
            Module="modules/economy"
            Store="useEconomyStore"
            UIComponents="AuctionCard, ItemCard, TradeForm, PriceDisplay"
            Forms="AuctionBidForm, TradeForm"
            State="auctions, trades, market"
        }
    }
    if ($path -match "/gameplay/combat/|/combat/") {
        return @{
            Module="modules/combat"
            Store="useCombatStore"
            UIComponents="WeaponCard, HealthBar, AbilityButton, AmmoDisplay"
            Forms="WeaponConfigForm, AbilityForm"
            State="weapons, abilities, combat"
        }
    }
    if ($path -match "/gameplay/world/|/locations/|/events/") {
        return @{
            Module="modules/world"
            Store="useWorldStore"
            UIComponents="LocationCard, EventCard, MapView"
            Forms="TravelForm, EventForm"
            State="locations, events, world"
        }
    }
    if ($path -match "/gameplay/progression/|/progression/") {
        return @{
            Module="modules/progression"
            Store="useProgressionStore"
            UIComponents="SkillTree, LevelProgress, StatBlock"
            Forms="SkillAllocationForm"
            State="skills, level, stats"
        }
    }
    if ($path -match "/narrative/|/quests/") {
        return @{
            Module="modules/narrative"
            Store="useNarrativeStore"
            UIComponents="QuestCard, DialogueBox, StoryPanel"
            Forms="QuestAcceptForm, DialogueChoiceForm"
            State="quests, dialogues, story"
        }
    }
    if ($path -match "/auth/|/characters/") {
        return @{
            Module="modules/auth"
            Store="useAuthStore"
            UIComponents="LoginForm, CharacterCard"
            Forms="LoginForm, CharacterCreationForm"
            State="user, character, session"
        }
    }
    if ($path -match "/lore/") {
        return @{
            Module="modules/lore"
            Store="useLoreStore"
            UIComponents="LoreCard, FactionBadge"
            Forms=""
            State="lore, factions"
        }
    }
    
    # Default
    return @{
        Module="modules/gameplay"
        Store="useGameplayStore"
        UIComponents="GameCard"
        Forms=""
        State="gameplay"
    }
}

# Функция для создания комментария об архитектуре
function New-ArchitectureComment {
    param(
        [hashtable]$Microservice,
        [hashtable]$Frontend,
        [string]$APIPath
    )
    
    $apiBase = ($APIPath -replace '\\', '/') -replace '(/[^/]+\.yaml$)', '/*'
    
    $comment = @"
# Target Architecture:
# - Microservice: $($Microservice.Name) (port $($Microservice.Port))
# - Frontend Module: $($Frontend.Module)
# - UI Components: @shared/ui ($($Frontend.UIComponents))$(if($Frontend.Forms){", @shared/forms ($($Frontend.Forms))"})
# - State: $($Frontend.Store) ($($Frontend.State))
# - API Base: $apiBase

"@
    
    return $comment
}

# Функция для проверки наличия комментария об архитектуре
function Test-HasArchitectureComment {
    param([string]$Content)
    
    return $Content -match "# Target Architecture:"
}

# Функция для обработки файла
function Update-OpenAPIFile {
    param(
        [string]$FilePath,
        [string]$RelativePath
    )
    
    if ($Verbose) {
        Write-Host "Обработка: $RelativePath" -ForegroundColor Cyan
    }
    
    # Читаем файл
    $content = Get-Content -Path $FilePath -Raw -Encoding UTF8
    
    # Проверяем, есть ли уже комментарий
    if (Test-HasArchitectureComment -Content $content) {
        if ($Verbose) {
            Write-Host "  ✓ Уже содержит комментарий об архитектуре" -ForegroundColor Green
        }
        return $false
    }
    
    # Определяем микросервис и модуль
    $microservice = Get-Microservice -Path $RelativePath
    $frontend = Get-FrontendModule -Path $RelativePath
    
    # Создаём комментарий
    $archComment = New-ArchitectureComment -Microservice $microservice -Frontend $frontend -APIPath $RelativePath
    
    # Проверяем, начинается ли файл с "openapi:"
    if ($content -match "^openapi:\s*\d+\.\d+\.\d+") {
        # Добавляем комментарий после строки openapi
        $newContent = $content -replace "(openapi:\s*\d+\.\d+\.\d+)", "`$1`n$archComment"
        
        if (-not $DryRun) {
            Set-Content -Path $FilePath -Value $newContent -Encoding UTF8 -NoNewline
            Write-Host "  ✓ Добавлен комментарий: $($microservice.Name) → $($frontend.Module)" -ForegroundColor Green
        } else {
            Write-Host "  [DRY RUN] Будет добавлен: $($microservice.Name) → $($frontend.Module)" -ForegroundColor Yellow
        }
        
        return $true
    } else {
        Write-Host "  ✗ Файл не начинается с 'openapi:', пропуск" -ForegroundColor Red
        return $false
    }
}

# Основная логика
Write-Host "`n=== Добавление комментариев об архитектуре в OpenAPI файлы ===" -ForegroundColor Magenta
Write-Host "Корневой путь: $RootPath" -ForegroundColor Magenta
if ($DryRun) {
    Write-Host "РЕЖИМ ТЕСТИРОВАНИЯ (изменения не будут применены)" -ForegroundColor Yellow
}
Write-Host ""

# Получаем все YAML файлы
$yamlFiles = Get-ChildItem -Path $RootPath -Filter "*.yaml" -Recurse -File

Write-Host "Найдено файлов: $($yamlFiles.Count)" -ForegroundColor Cyan
Write-Host ""

$updated = 0
$skipped = 0
$errors = 0

foreach ($file in $yamlFiles) {
    $relativePath = $file.FullName.Substring($PWD.Path.Length + 1)
    
    try {
        $result = Update-OpenAPIFile -FilePath $file.FullName -RelativePath $relativePath
        if ($result) {
            $updated++
        } else {
            $skipped++
        }
    } catch {
        Write-Host "  ✗ Ошибка: $_" -ForegroundColor Red
        $errors++
    }
}

Write-Host ""
Write-Host "=== Итого ===" -ForegroundColor Magenta
Write-Host "Обработано файлов: $($yamlFiles.Count)" -ForegroundColor Cyan
Write-Host "Обновлено: $updated" -ForegroundColor Green
Write-Host "Пропущено (уже содержат комментарии): $skipped" -ForegroundColor Yellow
Write-Host "Ошибок: $errors" -ForegroundColor Red

if ($DryRun) {
    Write-Host "`nДля применения изменений запустите без флага -DryRun" -ForegroundColor Yellow
}

Write-Host ""

