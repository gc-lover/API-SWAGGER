# Find unprocessed ready documents in gameplay
$brainPath = "C:\NECPGAME\.BRAIN\02-gameplay"
$readyFiles = @()

Get-ChildItem -Path $brainPath -Filter "*.md" -Recurse | ForEach-Object {
    if ($_.DirectoryName -notmatch '(\\\.git|\\scripts|\\06-tasks\\active|\\08-references|\\09-reports)') {
        $content = Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue
        if ($content -match 'api-readiness.*ready' -and $content -notmatch 'API Tasks Status') {
            $readyFiles += $_.FullName
        }
    }
}

Write-Host "Found $($readyFiles.Count) unprocessed ready files:"
$readyFiles | ForEach-Object { 
    Write-Host $_
}

