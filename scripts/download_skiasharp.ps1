# ============================================================
# Script PowerShell para baixar SkiaSharp Native Libraries
# ============================================================
# Este script baixa as bibliotecas nativas do SkiaSharp diretamente
# do NuGet, sem necessidade de dependências Dart extras.
#
# Uso: .\scripts\download_skiasharp.ps1
# ============================================================

$version = "3.119.1"
$outputDir = "native/libs/skiasharp"
$tempDir = "$env:TEMP/skiasharp-download"

Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  SkiaSharp Native Library Downloader" -ForegroundColor Cyan
Write-Host "  Version: $version" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Criar diretórios
New-Item -ItemType Directory -Force -Path "$outputDir/win-x64" | Out-Null
New-Item -ItemType Directory -Force -Path "$outputDir/win-x86" | Out-Null
New-Item -ItemType Directory -Force -Path "$outputDir/win-arm64" | Out-Null
New-Item -ItemType Directory -Force -Path "$outputDir/linux-x64" | Out-Null
New-Item -ItemType Directory -Force -Path "$outputDir/linux-arm64" | Out-Null
New-Item -ItemType Directory -Force -Path "$outputDir/linux-musl-x64" | Out-Null
New-Item -ItemType Directory -Force -Path "$outputDir/osx-x64" | Out-Null
New-Item -ItemType Directory -Force -Path "$outputDir/osx-arm64" | Out-Null
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

function Download-NuGetPackage {
    param(
        [string]$PackageName,
        [string]$Version,
        [string]$TempDir
    )
    
    $url = "https://www.nuget.org/api/v2/package/$PackageName/$Version"
    $nupkgPath = "$TempDir/$PackageName.nupkg"
    $extractPath = "$TempDir/$PackageName"
    
    Write-Host "📦 Baixando $PackageName..." -ForegroundColor Yellow
    
    try {
        Invoke-WebRequest -Uri $url -OutFile $nupkgPath -UseBasicParsing
        Write-Host "   ✅ Download concluído" -ForegroundColor Green
        
        # Extract (nupkg é um ZIP)
        if (Test-Path $extractPath) {
            Remove-Item -Recurse -Force $extractPath
        }
        Expand-Archive -Path $nupkgPath -DestinationPath $extractPath -Force
        Write-Host "   ✅ Extraído" -ForegroundColor Green
        
        return $extractPath
    }
    catch {
        Write-Host "   ❌ Erro: $_" -ForegroundColor Red
        return $null
    }
}

function Copy-Library {
    param(
        [string]$Source,
        [string]$Destination,
        [string]$Name
    )
    
    if (Test-Path $Source) {
        Copy-Item $Source $Destination -Force
        $size = (Get-Item $Destination).Length / 1MB
        Write-Host "   📁 $Name ({0:N2} MB)" -f $size -ForegroundColor Green
    }
    else {
        Write-Host "   ⚠️ Não encontrado: $Source" -ForegroundColor Yellow
    }
}

# ============================================================
# Download Win32
# ============================================================
Write-Host ""
Write-Host "🪟 Windows Libraries" -ForegroundColor Cyan
$winPath = Download-NuGetPackage -PackageName "SkiaSharp.NativeAssets.Win32" -Version $version -TempDir $tempDir

if ($winPath) {
    Copy-Library "$winPath/runtimes/win-x64/native/libSkiaSharp.dll" "$outputDir/win-x64/libSkiaSharp.dll" "win-x64/libSkiaSharp.dll"
    Copy-Library "$winPath/runtimes/win-x86/native/libSkiaSharp.dll" "$outputDir/win-x86/libSkiaSharp.dll" "win-x86/libSkiaSharp.dll"
    Copy-Library "$winPath/runtimes/win-arm64/native/libSkiaSharp.dll" "$outputDir/win-arm64/libSkiaSharp.dll" "win-arm64/libSkiaSharp.dll"
}

# ============================================================
# Download Linux
# ============================================================
Write-Host ""
Write-Host "🐧 Linux Libraries" -ForegroundColor Cyan
$linuxPath = Download-NuGetPackage -PackageName "SkiaSharp.NativeAssets.Linux" -Version $version -TempDir $tempDir

if ($linuxPath) {
    Copy-Library "$linuxPath/runtimes/linux-x64/native/libSkiaSharp.so" "$outputDir/linux-x64/libSkiaSharp.so" "linux-x64/libSkiaSharp.so"
    Copy-Library "$linuxPath/runtimes/linux-arm64/native/libSkiaSharp.so" "$outputDir/linux-arm64/libSkiaSharp.so" "linux-arm64/libSkiaSharp.so"
    Copy-Library "$linuxPath/runtimes/linux-musl-x64/native/libSkiaSharp.so" "$outputDir/linux-musl-x64/libSkiaSharp.so" "linux-musl-x64/libSkiaSharp.so"
}

# ============================================================
# Download macOS
# ============================================================
Write-Host ""
Write-Host "🍎 macOS Libraries" -ForegroundColor Cyan
$macPath = Download-NuGetPackage -PackageName "SkiaSharp.NativeAssets.macOS" -Version $version -TempDir $tempDir

if ($macPath) {
    # Note: macOS usa 'osx' sem arquitetura no path em algumas versões
    $macLibPath = "$macPath/runtimes/osx/native/libSkiaSharp.dylib"
    if (-not (Test-Path $macLibPath)) {
        $macLibPath = "$macPath/runtimes/osx-x64/native/libSkiaSharp.dylib"
    }
    if (Test-Path $macLibPath) {
        Copy-Item $macLibPath "$outputDir/osx-x64/libSkiaSharp.dylib" -Force
        $size = (Get-Item "$outputDir/osx-x64/libSkiaSharp.dylib").Length / 1MB
        Write-Host "   📁 osx-x64/libSkiaSharp.dylib ({0:N2} MB)" -f $size -ForegroundColor Green
    }
    
    # ARM64
    $macArm64Path = "$macPath/runtimes/osx-arm64/native/libSkiaSharp.dylib"
    if (Test-Path $macArm64Path) {
        Copy-Library $macArm64Path "$outputDir/osx-arm64/libSkiaSharp.dylib" "osx-arm64/libSkiaSharp.dylib"
    }
}

# ============================================================
# Cleanup
# ============================================================
Write-Host ""
Write-Host "🧹 Limpando arquivos temporários..." -ForegroundColor Gray
Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue

# ============================================================
# Summary
# ============================================================
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Download Concluído!" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Bibliotecas disponíveis em: $outputDir" -ForegroundColor White
Write-Host ""

# List files
Write-Host "Arquivos:" -ForegroundColor Yellow
Get-ChildItem -Path $outputDir -Recurse -File | ForEach-Object {
    $relativePath = $_.FullName.Replace((Get-Location).Path + "\", "")
    $size = $_.Length / 1MB
    Write-Host "  $relativePath ({0:N2} MB)" -f $size
}
