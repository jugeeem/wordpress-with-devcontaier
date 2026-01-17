#!/usr/bin/env pwsh

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "WordPress Dev Container Setup" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check if .env file exists
if (-not (Test-Path ".env")) {
    Write-Host "❌ Error: .env file not found!" -ForegroundColor Red
    Write-Host "Please copy .env.example to .env and configure your database credentials." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Run the following command:" -ForegroundColor Yellow
    Write-Host "  Copy-Item .env.example .env" -ForegroundColor White
    Write-Host ""
    exit 1
}

Write-Host "✅ .env file found" -ForegroundColor Green
Write-Host ""

# Check if WordPress is already downloaded
if ((Test-Path "wordpress\index.php") -and (Test-Path "wordpress\wp-settings.php")) {
    Write-Host "✅ WordPress is already installed" -ForegroundColor Green
} else {
    Write-Host "📦 Downloading WordPress..." -ForegroundColor Yellow
    
    # Create wordpress directory if it doesn't exist
    if (-not (Test-Path "wordpress")) {
        New-Item -ItemType Directory -Path "wordpress" | Out-Null
    }
    
    # Download latest WordPress
    $tempZip = "$env:TEMP\wordpress.zip"
    Invoke-WebRequest -Uri "https://ja.wordpress.org/latest-ja.zip" -OutFile $tempZip
    
    Write-Host "📂 Extracting WordPress files..." -ForegroundColor Yellow
    Expand-Archive -Path $tempZip -DestinationPath "$env:TEMP" -Force
    
    # Move WordPress files to the wordpress directory
    Copy-Item -Path "$env:TEMP\wordpress\*" -Destination "wordpress\" -Recurse -Force
    
    # Clean up
    Remove-Item $tempZip
    Remove-Item "$env:TEMP\wordpress" -Recurse -Force
    
    Write-Host "✅ WordPress downloaded successfully" -ForegroundColor Green
}

Write-Host ""
Write-Host "📝 Copying wp-config.php template if needed..." -ForegroundColor Yellow
if (-not (Test-Path "wordpress\wp-config.php")) {
    if (Test-Path "wp-config-template.php") {
        Copy-Item "wp-config-template.php" "wordpress\wp-config.php"
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "✅ Setup completed successfully!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "WordPress is now accessible at:" -ForegroundColor White
Write-Host "  🌐 http://localhost:8080" -ForegroundColor Cyan
Write-Host ""
Write-Host "phpMyAdmin is accessible at:" -ForegroundColor White
Write-Host "  🔧 http://localhost:8081" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor White
Write-Host "  1. Start Docker Desktop" -ForegroundColor White
Write-Host "  2. Open this folder in VS Code" -ForegroundColor White
Write-Host "  3. Click 'Reopen in Container' when prompted" -ForegroundColor White
Write-Host "  4. Open http://localhost:8080 in your browser" -ForegroundColor White
Write-Host "  5. Complete the WordPress installation wizard" -ForegroundColor White
Write-Host ""
