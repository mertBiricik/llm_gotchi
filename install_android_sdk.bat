@echo off
REM Android SDK Installation and APK Build Script for Windows
REM Run this script to set up Android development environment and build APK

setlocal enabledelayedexpansion

echo === Installing Android SDK and Building LDR Gotchi APK ===

REM 1. Create Android SDK directory
echo Creating Android SDK directory...
if not exist "%USERPROFILE%\android-sdk\cmdline-tools" mkdir "%USERPROFILE%\android-sdk\cmdline-tools"
cd /d "%USERPROFILE%\android-sdk\cmdline-tools"

REM 2. Download Android command line tools (Windows version)
echo Downloading Android command line tools...
curl -o commandlinetools-win-9477386_latest.zip https://dl.google.com/android/repository/commandlinetools-win-9477386_latest.zip

REM 3. Extract command line tools
echo Extracting command line tools...
powershell -command "Expand-Archive -Path 'commandlinetools-win-9477386_latest.zip' -DestinationPath '.' -Force"
move cmdline-tools latest

REM 4. Set environment variables
echo Setting up environment variables...
set ANDROID_HOME=%USERPROFILE%\android-sdk
set PATH=%ANDROID_HOME%\cmdline-tools\latest\bin;%ANDROID_HOME%\platform-tools;%PATH%

REM 5. Accept all licenses automatically
echo Accepting Android SDK licenses...
echo y | sdkmanager --licenses >nul 2>&1

REM 6. Install required SDK components
echo Installing Android SDK components...
sdkmanager --install "platforms;android-34" "build-tools;34.0.0" "platform-tools" >nul

REM 7. Navigate to Flutter project
echo Navigating to Flutter project...
cd /d "D:\courses\llm_gotchi"

REM 8. Update local.properties
echo Updating local.properties...
echo sdk.dir=%USERPROFILE%\android-sdk > android\local.properties

REM 9. Set up Flutter environment (assuming Flutter is in PATH)
echo Setting up Flutter environment...
REM Add Flutter to PATH if needed

REM 10. Get Flutter dependencies
echo Getting Flutter dependencies...
flutter pub get

REM 11. Build APK
echo Building release APK...
flutter build apk --release

REM 12. Check if APK was created
set APK_PATH=build\app\outputs\flutter-apk\app-release.apk
if exist "%APK_PATH%" (
    echo.
    echo ✅ SUCCESS! APK built successfully!
    echo 📱 APK location: %APK_PATH%
    echo 📁 Full path: %CD%\%APK_PATH%
    echo.
    for %%A in ("%APK_PATH%") do echo File size: %%~zA bytes
    echo.
    echo 🚀 You can now:
    echo 1. Copy the APK to your Android device
    echo 2. Enable 'Install from unknown sources' in Android settings
    echo 3. Install the APK and enjoy LDR Gotchi!
) else (
    echo ❌ APK build failed. Check the output above for errors.
    exit /b 1
)

echo.
echo === Installation and Build Complete ===
pause 