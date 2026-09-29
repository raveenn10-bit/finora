# Finora — Platform Setup Guide

> Run these steps **once** after cloning or generating the project
> to make `local_auth` and biometric features work on real devices.

---

## 1. Generate Platform Harnesses

```bash
flutter create --org com.finora .
```

This generates `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/` without overwriting existing Dart code.

---

## 2. Android

### 2a. Use `FlutterFragmentActivity`

`android/app/src/main/kotlin/com/finora/finora/MainActivity.kt`

```kotlin
package com.finora.finora

import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity()
```

### 2b. Add Biometric Permission

`android/app/src/main/AndroidManifest.xml` — inside `<manifest>`:

```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC" />
```

### 2c. Minimum SDK

`android/app/build.gradle` → set `minSdkVersion 23` (required by `local_auth`).

---

## 3. iOS

### 3a. Face ID Usage Description

`ios/Runner/Info.plist` — inside `<dict>`:

```xml
<key>NSFaceIDUsageDescription</key>
<string>Finora uses Face ID to securely protect your financial data.</string>
```

### 3b. Minimum Deployment Target

In `ios/Podfile`, ensure:
```ruby
platform :ios, '12.0'
```

---

## 4. Install Dependencies

```bash
flutter pub get
```

---

## 5. Run

```bash
# Android
flutter run -d android

# iOS (requires macOS + Xcode)
flutter run -d ios
```
