#!/bin/bash

# Android SDK Installation and APK Build Script for WSL/Linux
# Run this script to set up Android development environment and build APK

set -e

echo "=== Installing Android SDK and Building LDR Gotchi APK ==="

# 1. Create Android SDK directory
echo "Creating Android SDK directory..."
mkdir -p ~/android-sdk/cmdline-tools
cd ~/android-sdk/cmdline-tools

# 2. Clean up any previous installation
echo "Cleaning up previous installation..."
rm -rf latest commandlinetools-linux-9477386_latest.zip

# 3. Download Android command line tools
echo "Downloading Android command line tools..."
wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip

# 4. Extract command line tools
echo "Extracting command line tools..."
unzip -q commandlinetools-linux-9477386_latest.zip
mv cmdline-tools latest

# 5. Set environment variables
echo "Setting up environment variables..."
export ANDROID_HOME=~/android-sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH

# 6. Accept all licenses automatically
echo "Accepting Android SDK licenses..."
yes | sdkmanager --licenses > /dev/null 2>&1

# 7. Install required SDK components
echo "Installing Android SDK components..."
sdkmanager --install "platforms;android-34" "build-tools;34.0.0" "platform-tools" > /dev/null

# 8. Navigate to Flutter project
echo "Navigating to Flutter project..."
cd /mnt/d/courses/llm_gotchi

# 9. Update local.properties
echo "Updating local.properties..."
echo "sdk.dir=$HOME/android-sdk" > android/local.properties

# 10. Set up Flutter environment
echo "Setting up Flutter environment..."
export PATH="$HOME/flutter/bin:$PATH"

echo "Upgrading Flutter SDK..."
flutter upgrade --force

# 11. Get Flutter dependencies
echo "Getting Flutter dependencies..."
flutter pub get

# 12. Fix gradle wrapper permissions and line endings
echo "Fixing gradle wrapper..."
chmod +x android/gradlew
dos2unix android/gradlew 2>/dev/null || true

# 13. Fix gradle wrapper jar if corrupted
if ! android/gradlew --version >/dev/null 2>&1; then
    echo "Regenerating gradle wrapper files..."
    cd android
    rm -rf gradle/wrapper
    mkdir -p gradle/wrapper
    cd gradle/wrapper
    wget -q https://raw.githubusercontent.com/gradle/gradle/master/gradle/wrapper/gradle-wrapper.jar
    echo 'distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.7-bin.zip
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists' > gradle-wrapper.properties
    cd ../..
fi

# 14. Build APK
echo "Building release APK..."
flutter build apk --release --no-shrink

# 15. Check if APK was created
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
if [ -f "$APK_PATH" ]; then
    echo ""
    echo "✅ SUCCESS! APK built successfully!"
    echo "📱 APK location: $APK_PATH"
    echo "📁 Full path: $(pwd)/$APK_PATH"
    echo ""
    echo "File size: $(du -h $APK_PATH | cut -f1)"
    echo ""
    echo "🚀 You can now:"
    echo "1. Copy the APK to your Android device"
    echo "2. Enable 'Install from unknown sources' in Android settings"
    echo "3. Install the APK and enjoy LDR Gotchi!"
else
    echo "❌ APK build failed. Check the output above for errors."
    exit 1
fi

echo ""
echo "=== Installation and Build Complete ===" 