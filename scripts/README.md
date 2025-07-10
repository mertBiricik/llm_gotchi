# Release Scripts

These scripts automate the process of creating releases for LDR Gotchi.

## Prerequisites

1. **Push your code to GitHub**:
   ```bash
   git add .
   git commit -m "Ready for release"
   git push origin main
   ```

2. **Ensure GitHub Actions is enabled** in your repository:
   - Go to your GitHub repository
   - Click on "Actions" tab
   - Enable workflows if prompted

## Creating a Release

### For Linux/WSL/macOS:
```bash
./scripts/release.sh 1.0.0
```

### For Windows:
```cmd
scripts\release.bat 1.0.0
```

## What happens when you run the script:

1. **Version Update**: Updates `pubspec.yaml` with the new version
2. **Git Commit**: Commits the version change
3. **Tag Creation**: Creates a git tag (e.g., `v1.0.0`)
4. **Push to GitHub**: Pushes the code and tag to GitHub

## GitHub Actions will then:

1. **Build APK**: Automatically builds a release APK
2. **Create Release**: Creates a new GitHub release with release notes
3. **Upload APK**: Attaches the APK file to the release

## Monitoring the Build

After running the release script:

1. Go to your GitHub repository
2. Click on the "Actions" tab
3. You'll see the build progress
4. Once complete, check the "Releases" section

## Manual Release (Alternative)

If you prefer manual control:

1. **Update version** in `pubspec.yaml`
2. **Commit and push** your changes
3. **Create a tag**:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
4. GitHub Actions will handle the rest

## Troubleshooting

- **Build fails**: Check the Actions tab for detailed error logs
- **No APK generated**: Ensure your Flutter app builds locally first
- **Tag already exists**: Use a different version number

The APK will be available for download in the GitHub Releases section once the build completes. 