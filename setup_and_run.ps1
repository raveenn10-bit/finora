# Flutter SDK Setup & Run Script for Finora
# Runs after flutter_sdk.zip download completes

$zipPath    = "$env:USERPROFILE\flutter_sdk.zip"
$installDir = "F:\flutter"
$projectDir = "F:\Finora App cdx"
$flutter    = "$installDir\bin\flutter.bat"

# ── Step 1: Extract ───────────────────────────────────────
Write-Host "`n=== Step 1: Extracting Flutter SDK ===" -ForegroundColor Cyan
if (-not (Test-Path $installDir)) {
    Write-Host "Extracting $zipPath to F:\ ..."
    Expand-Archive -Path $zipPath -DestinationPath "F:\" -Force
    Write-Host "Extracted OK" -ForegroundColor Green
} else {
    Write-Host "Flutter already at $installDir" -ForegroundColor Yellow
}

# ── Step 2: PATH ──────────────────────────────────────────
Write-Host "`n=== Step 2: Adding Flutter to PATH ===" -ForegroundColor Cyan
$flutterBin  = "$installDir\bin"
$currentPath = [System.Environment]::GetEnvironmentVariable("PATH","User")
if ($currentPath -notlike "*$flutterBin*") {
    [System.Environment]::SetEnvironmentVariable("PATH","$currentPath;$flutterBin","User")
    $env:PATH += ";$flutterBin"
    Write-Host "Added to PATH: $flutterBin" -ForegroundColor Green
} else {
    Write-Host "Already in PATH" -ForegroundColor Yellow
}

# ── Step 3: Flutter Doctor ────────────────────────────────
Write-Host "`n=== Step 3: Flutter Doctor ===" -ForegroundColor Cyan
& $flutter doctor

# ── Step 4: Create Platform Harnesses ────────────────────
Write-Host "`n=== Step 4: flutter create ===" -ForegroundColor Cyan
Set-Location $projectDir
& $flutter create --org com.finora . 2>&1 | Where-Object { $_ -notmatch "^Unchanged" }

# ── Step 5: Fix MainActivity.kt ──────────────────────────
Write-Host "`n=== Step 5: Fix MainActivity.kt ===" -ForegroundColor Cyan
$mainActivityPath = Get-ChildItem -Path "$projectDir\android" -Filter "MainActivity.kt" -Recurse -ErrorAction SilentlyContinue |
    Select-Object -First 1 -ExpandProperty FullName

if ($mainActivityPath) {
    $existingContent = Get-Content $mainActivityPath -Raw
    $pkgMatch = [regex]::Match($existingContent, 'package\s+([\w.]+)')
    $pkg = if ($pkgMatch.Success) { $pkgMatch.Groups[1].Value } else { "com.finora.finora" }
    $fixed = "package $pkg`n`nimport io.flutter.embedding.android.FlutterFragmentActivity`n`nclass MainActivity : FlutterFragmentActivity()`n"
    Set-Content -Path $mainActivityPath -Value $fixed -Encoding UTF8
    Write-Host "MainActivity.kt fixed (package: $pkg)" -ForegroundColor Green
} else {
    Write-Host "MainActivity.kt not found" -ForegroundColor Red
}

# ── Step 6: Add Biometric Permission ─────────────────────
Write-Host "`n=== Step 6: AndroidManifest Biometric Permission ===" -ForegroundColor Cyan
$manifestPath = "$projectDir\android\app\src\main\AndroidManifest.xml"
if (Test-Path $manifestPath) {
    $manifest = Get-Content $manifestPath -Raw
    if ($manifest -notlike "*USE_BIOMETRIC*") {
        $perm = '    <uses-permission android:name="android.permission.USE_BIOMETRIC" />'
        $manifest = $manifest -replace "(<manifest[^>]*>)", "`$1`n$perm"
        Set-Content -Path $manifestPath -Value $manifest -Encoding UTF8
        Write-Host "USE_BIOMETRIC permission added" -ForegroundColor Green
    } else {
        Write-Host "Permission already present" -ForegroundColor Yellow
    }
} else {
    Write-Host "AndroidManifest.xml not found" -ForegroundColor Red
}

# ── Step 7: flutter pub get ───────────────────────────────
Write-Host "`n=== Step 7: flutter pub get ===" -ForegroundColor Cyan
& $flutter pub get

# ── Step 8: Devices ───────────────────────────────────────
Write-Host "`n=== Step 8: Connected Devices ===" -ForegroundColor Cyan
& $flutter devices

Write-Host "`n=== ALL DONE ===" -ForegroundColor Green
Write-Host "Run on Android : flutter run -d android" -ForegroundColor White
Write-Host "Run on Chrome  : flutter run -d chrome"  -ForegroundColor White
Write-Host "Run on Windows : flutter run -d windows" -ForegroundColor White
