# Installation Guide - Building LDR Gotchi APK

## Option 1: Automated Installation (Recommended)

### For WSL/Linux:
```bash
./install_android_sdk.sh
```

### For Windows:
```cmd
install_android_sdk.bat
```

## Option 2: Manual Installation

### Prerequisites
- Java 17 or higher
- Flutter SDK installed
- Git

### Step-by-Step Manual Installation

#### 1. Download Android Command Line Tools

**Linux/WSL:**
```bash
mkdir -p ~/android-sdk/cmdline-tools
cd ~/android-sdk/cmdline-tools
wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
unzip commandlinetools-linux-9477386_latest.zip
mv cmdline-tools latest
```

**Windows:**
```cmd
mkdir "%USERPROFILE%\android-sdk\cmdline-tools"
cd /d "%USERPROFILE%\android-sdk\cmdline-tools"
curl -o commandlinetools-win-9477386_latest.zip https://dl.google.com/android/repository/commandlinetools-win-9477386_latest.zip
powershell -command "Expand-Archive -Path 'commandlinetools-win-9477386_latest.zip' -DestinationPath '.' -Force"
move cmdline-tools latest
```

#### 2. Set Environment Variables

**Linux/WSL:**
```bash
export ANDROID_HOME=~/android-sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH
```

**Windows:**
```cmd
set ANDROID_HOME=%USERPROFILE%\android-sdk
set PATH=%ANDROID_HOME%\cmdline-tools\latest\bin;%ANDROID_HOME%\platform-tools;%PATH%
```

#### 3. Accept Android SDK Licenses

**Linux/WSL:**
```bash
yes | sdkmanager --licenses
```

**Windows:**
```cmd
echo y | sdkmanager --licenses
```

#### 4. Install Required Android SDK Components

```bash
sdkmanager --install "platforms;android-34" "build-tools;34.0.0" "platform-tools"
```

#### 5. Configure Flutter Project

**Linux/WSL:**
```bash
cd /mnt/d/courses/llm_gotchi
echo "sdk.dir=$HOME/android-sdk" > android/local.properties
```

**Windows:**
```cmd
cd /d "D:\courses\llm_gotchi"
echo sdk.dir=%USERPROFILE%\android-sdk > android\local.properties
```

#### 6. Build APK

```bash
flutter pub get
flutter build apk --release
```

#### 7. Locate Your APK

The APK will be created at:
```
build/app/outputs/flutter-apk/app-release.apk
```

## Option 3: GitHub Actions (Automated CI/CD)

Push your code to GitHub and use the release script:

```bash
./scripts/release.sh 1.0.0
```

This will automatically build the APK and create a GitHub release.

## Troubleshooting

### Common Issues:

1. **Flutter not found**: Ensure Flutter is in your PATH
2. **Java not found**: Install Java 17+ and add to PATH
3. **Gradle issues**: Delete `build` folder and retry
4. **Permission denied**: Run `chmod +x install_android_sdk.sh` first

### Verification Commands:

```bash
flutter doctor          # Check Flutter installation
java --version          # Check Java version
$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --list  # Check Android SDK
```

## APK Installation on Android

1. Transfer the APK to your Android device
2. Go to Settings > Security > Install from unknown sources (enable)
3. Use a file manager to locate and install the APK
4. Launch "LDR Gotchi" from your app drawer

## File Sizes (Approximate)

- APK size: ~15-25 MB
- Installation size: ~50-80 MB

The APK will work on Android 5.0+ (API level 21 and above). 