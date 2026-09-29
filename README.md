# Finora 💳

> **Track. Save. Grow.** — Premium biometric personal finance application built with Flutter.

---

## Download Finora

Pre-compiled Android release APKs are available directly from the repository's **GitHub Releases** page:

👉 **[Download Latest Finora Release](https://github.com/raveenn10-bit/finora/releases)**

### Installation on Android:
1. Open the [Releases page](https://github.com/raveenn10-bit/finora/releases) on your Android device.
2. Under **Assets**, tap `Finora-v<VERSION>.apk` (e.g., `Finora-v1.0.0.apk`) to download.
3. Once downloaded, open the APK file.
4. If prompted by Android, enable **"Install unknown apps"** / **"Allow from this source"** in your browser/file manager settings to complete installation.

---

## Release Pipeline & Automation

This repository uses automated CI/CD via **GitHub Actions** (`.github/workflows/android-release.yml`).

### How It Works:
```
git tag v1.0.0 ──► git push origin v1.0.0 ──► GitHub Actions ──► APK Build ──► GitHub Release (v1.0.0)
```

1. **Trigger**: Pushing a version tag matching `v*` (e.g. `v1.0.0`, `v1.0.1`, `v1.1.0`).
2. **Quality Gates**:
   - `flutter pub get`
   - `dart format --set-exit-if-changed .`
   - `flutter analyze`
   - `flutter test`
3. **Build**: Compiles `flutter build apk --release`.
4. **Artifact Renaming**: Packages the APK as `Finora-v<VERSION>.apk`.
5. **Distribution**: Automatically creates a GitHub Release and attaches the standalone APK asset.

---

## Creating a New Release

To release a new version of Finora, run the following commands:

```bash
# 1. Ensure you are on main and all changes are committed
git checkout main
git pull origin main

# 2. Create a new semver tag (e.g. v1.0.0)
git tag v1.0.0

# 3. Push the tag to GitHub
git push origin v1.0.0
```

Once pushed, navigate to the **Actions** tab in GitHub to watch the build pipeline. After ~3-4 minutes, the new version will appear on the **Releases** page with the downloadable APK.

---

## Release Signing (Optional Production Keystore)

By default, GitHub Actions builds using a fallback signing configuration. For production Google Play / custom keystore signing, configure the following **GitHub Repository Secrets** (`Settings > Secrets and variables > Actions`):

| Secret Name | Description |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | Base64-encoded string of your `upload-keystore.jks` file |
| `ANDROID_KEYSTORE_PASSWORD` | Password for the keystore file |
| `ANDROID_KEY_ALIAS` | Key alias (e.g., `upload`) |
| `ANDROID_KEY_PASSWORD` | Password for the key alias |

To generate the Base64 keystore string on Windows:
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("upload-keystore.jks")) | Set-Clipboard
```

---

## Local Development

```bash
# Install dependencies
flutter pub get

# Format code
dart format .

# Run static analysis
flutter analyze

# Run tests
flutter test

# Run in Chrome / Web
flutter run -d chrome

# Run on connected Android device
flutter run -d android
```
