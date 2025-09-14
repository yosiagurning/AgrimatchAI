# AgriMatch App (Flutter)
Generated on 2025-08-27T09:30:17.164680

## Quick Start
1. Ensure Flutter SDK is installed.
2. Create a fresh project first (to generate android/ios/web/macos folders):
   ```bash
   flutter create agrimatch_app
   ```
3. Overwrite the generated `pubspec.yaml` and the whole `lib/` folder with the ones from this package.
4. Inside the new project root, run:
   ```bash
   flutter pub get
   flutter run
   ```

## What you get
- Onboarding → Auth → Dashboard → Soil Analysis (camera/galeri + multipart upload) → History → Chat → Profile.
- Provider state mgmt, http client, secure storage, sqflite scaffold-ready.
- API endpoints are placeholders – change base URL in `lib/core/constants.dart` to your Python API.

## Env
- Dart >= 3.x, Flutter 3.x
