@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ==========================================
echo WordPress Dev Container Setup
echo ==========================================
echo.

REM Check if .env file exists
if not exist ".env" (
    echo ❌ Error: .env file not found!
    echo Please copy .env.example to .env and configure your database credentials.
    echo.
    echo Run the following command:
    echo   copy .env.example .env
    echo.
    pause
    exit /b 1
)

echo ✅ .env file found
echo.

REM Check if WordPress is already downloaded
if exist "wordpress\index.php" if exist "wordpress\wp-settings.php" (
    echo ✅ WordPress is already installed
    goto :permissions
)

echo 📦 Downloading WordPress...

REM Create wordpress directory if it doesn't exist
if not exist "wordpress" mkdir wordpress

REM Download WordPress using PowerShell
powershell -Command "& { Invoke-WebRequest -Uri 'https://ja.wordpress.org/latest-ja.zip' -OutFile '%TEMP%\wordpress.zip' }"

echo 📂 Extracting WordPress files...
powershell -Command "& { Expand-Archive -Path '%TEMP%\wordpress.zip' -DestinationPath '%TEMP%' -Force }"

REM Move WordPress files
xcopy /E /I /Y "%TEMP%\wordpress\*" "wordpress\"

REM Clean up
del "%TEMP%\wordpress.zip"
rmdir /S /Q "%TEMP%\wordpress"

echo ✅ WordPress downloaded successfully

:permissions
echo.
echo 📝 Copying wp-config.php template if needed...
if not exist "wordpress\wp-config.php" (
    if exist "wp-config-template.php" (
        copy "wp-config-template.php" "wordpress\wp-config.php"
    )
)

echo.
echo ==========================================
echo ✅ Setup completed successfully!
echo ==========================================
echo.
echo WordPress is now accessible at:
echo   🌐 http://localhost:8080
echo.
echo phpMyAdmin is accessible at:
echo   🔧 http://localhost:8081
echo.
echo Next steps:
echo   1. Start Docker Desktop
echo   2. Open this folder in VS Code
echo   3. Click "Reopen in Container" when prompted
echo   4. Open http://localhost:8080 in your browser
echo   5. Complete the WordPress installation wizard
echo.
pause
