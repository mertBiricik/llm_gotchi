@echo off
REM LDR Gotchi Release Script for Windows
REM Usage: scripts\release.bat <version>
REM Example: scripts\release.bat 1.0.0

if "%1"=="" (
    echo Usage: %0 ^<version^>
    echo Example: %0 1.0.0
    exit /b 1
)

set VERSION=%1
set TAG=v%VERSION%

echo Creating release for version %VERSION%...

REM Check if we're in a git repository
git rev-parse --git-dir >nul 2>&1
if errorlevel 1 (
    echo Error: Not in a git repository
    exit /b 1
)

REM Check if there are uncommitted changes
git diff-index --quiet HEAD --
if errorlevel 1 (
    echo Error: You have uncommitted changes. Please commit or stash them first.
    exit /b 1
)

REM Update version in pubspec.yaml (Windows version)
echo Updating version in pubspec.yaml...
powershell -Command "(Get-Content pubspec.yaml) -replace 'version: .*', 'version: %VERSION%+1' | Set-Content pubspec.yaml"

REM Commit version update
git add pubspec.yaml
git commit -m "Bump version to %VERSION%"

REM Create and push tag
echo Creating tag %TAG%...
git tag -a "%TAG%" -m "Release %VERSION%"

echo Pushing to origin...
git push origin main
git push origin "%TAG%"

echo.
echo ✅ Release %VERSION% created successfully!
echo.
echo GitHub Actions will now:
echo 1. Build the APK automatically
echo 2. Create a GitHub release
echo 3. Upload the APK to the release
echo.
echo Check the Actions tab in your GitHub repository to monitor progress.
echo Release will be available at: https://github.com/[YOUR-USERNAME]/llm_gotchi/releases/tag/%TAG% 