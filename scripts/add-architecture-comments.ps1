# Add Architecture Comments to OpenAPI Files
# Script to add target architecture comments to OpenAPI specifications

param(
    [string]$RootPath = "api\v1",
    [switch]$DryRun = $false,
    [switch]$Verbose = $false
)

# Function to determine microservice by API path
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

# Function to determine frontend module by category
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

# Function to create architecture comment
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

# Function to check if architecture comment exists
function Test-HasArchitectureComment {
    param([string]$Content)
    
    return $Content -match "# Target Architecture:"
}

# Function to process file
function Update-OpenAPIFile {
    param(
        [string]$FilePath,
        [string]$RelativePath
    )
    
    if ($Verbose) {
        Write-Host "Processing: $RelativePath" -ForegroundColor Cyan
    }
    
    # Read file
    $content = Get-Content -Path $FilePath -Raw -Encoding UTF8
    
    # Check if comment already exists
    if (Test-HasArchitectureComment -Content $content) {
        if ($Verbose) {
            Write-Host "  Already has architecture comment" -ForegroundColor Green
        }
        return $false
    }
    
    # Determine microservice and module
    $microservice = Get-Microservice -Path $RelativePath
    $frontend = Get-FrontendModule -Path $RelativePath
    
    # Create comment
    $archComment = New-ArchitectureComment -Microservice $microservice -Frontend $frontend -APIPath $RelativePath
    
    # Check if file starts with "openapi:"
    if ($content -match "^openapi:\s*\d+\.\d+\.\d+") {
        # Add comment after openapi line
        $newContent = $content -replace "(openapi:\s*\d+\.\d+\.\d+)", "`$1`n$archComment"
        
        if (-not $DryRun) {
            Set-Content -Path $FilePath -Value $newContent -Encoding UTF8 -NoNewline
            Write-Host "  Added comment: $($microservice.Name) -> $($frontend.Module)" -ForegroundColor Green
        } else {
            Write-Host "  [DRY RUN] Will add: $($microservice.Name) -> $($frontend.Module)" -ForegroundColor Yellow
        }
        
        return $true
    } else {
        Write-Host "  File does not start with 'openapi:', skipping" -ForegroundColor Red
        return $false
    }
}

# Main logic
Write-Host "`n=== Adding Architecture Comments to OpenAPI Files ===" -ForegroundColor Magenta
Write-Host "Root path: $RootPath" -ForegroundColor Magenta
if ($DryRun) {
    Write-Host "DRY RUN MODE (changes will not be applied)" -ForegroundColor Yellow
}
Write-Host ""

# Get all YAML files
$yamlFiles = Get-ChildItem -Path $RootPath -Filter "*.yaml" -Recurse -File

Write-Host "Files found: $($yamlFiles.Count)" -ForegroundColor Cyan
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
        Write-Host "  Error: $_" -ForegroundColor Red
        $errors++
    }
}

Write-Host ""
Write-Host "=== Summary ===" -ForegroundColor Magenta
Write-Host "Processed files: $($yamlFiles.Count)" -ForegroundColor Cyan
Write-Host "Updated: $updated" -ForegroundColor Green
Write-Host "Skipped (already have comments): $skipped" -ForegroundColor Yellow
Write-Host "Errors: $errors" -ForegroundColor Red

if ($DryRun) {
    Write-Host "`nTo apply changes run without -DryRun flag" -ForegroundColor Yellow
}

Write-Host ""
