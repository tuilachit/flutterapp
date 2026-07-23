# ReturnPal development setup

## Prerequisites

- Flutter with Dart 3.6 support
- Git
- A Supabase project
- Android Studio for Android builds
- Xcode and CocoaPods for iOS builds

Confirm the local toolchain:

```bash
flutter doctor
flutter --version
```

## Install

```bash
git clone https://github.com/tuilachit/flutterapp.git
cd flutterapp
flutter pub get
```

## Configure Supabase

1. Create a Supabase project.
2. Run the migrations in [`supabase/migrations`](supabase/migrations) in chronological order.
3. Confirm Row Level Security is enabled and review every policy before using real data.
4. Copy the project URL and public anon key from the Supabase project settings.

The app reads configuration through Dart compile-time defines. No `.env` parser is included.

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-public-anon-key
```

For repeatable local commands, create an untracked shell script or IDE launch configuration. Do not commit credentials or service-role keys.

## Run by platform

```bash
# List targets
flutter devices

# Web
flutter run -d chrome \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-public-anon-key

# A connected simulator or device
flutter run -d DEVICE_ID \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-public-anon-key
```

## Validate

```bash
flutter analyze
flutter test
```

## Build

Supply the same defines to release builds:

```bash
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-public-anon-key

flutter build ios --release \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-public-anon-key
```

## Troubleshooting

- Run `flutter doctor -v` for missing platform dependencies.
- Run `flutter clean && flutter pub get` after SDK or dependency changes.
- Check that both defines are present if the app opens a configuration error screen.
- Review Supabase RLS policies when authenticated requests return permission errors.
- On iOS, run `pod install` inside `ios/` after native dependency changes.
