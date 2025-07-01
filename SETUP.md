# Return Clothing Tracker - Setup Guide

This guide will help you set up the Return Clothing Tracker app for development and production.

## 📋 Prerequisites

### Required Software
- Flutter SDK (3.6.1 or later)
- Dart SDK (included with Flutter)
- Android Studio or VS Code with Flutter extensions
- Git

### Platform-Specific Requirements

#### Android Development
- Android Studio
- Android SDK (API level 21 or higher)
- Java 11 or higher

#### iOS Development (macOS only)
- Xcode 12.0 or higher
- iOS Simulator or physical iOS device
- CocoaPods

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone <repository-url>
cd return_clothing_tracker
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run the App
```bash
flutter run
```

## 🔧 Environment Configuration

### Create Environment Files

Create a `.env` file in the project root with the following variables:

```env
# Supabase Configuration
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key

# Firebase Configuration
FIREBASE_PROJECT_ID=your_firebase_project_id
FIREBASE_API_KEY=your_firebase_api_key

# App Configuration
APP_NAME=Return Clothing Tracker
APP_VERSION=1.0.0
ENVIRONMENT=development
```

## 🔥 Firebase Setup

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Enable Authentication and Cloud Messaging

### 2. Configure Android
1. Add your Android package name: `com.returntracker.return_clothing_tracker`
2. Download `google-services.json`
3. Place it in `android/app/`

### 3. Configure iOS
1. Add your iOS bundle ID: `com.returntracker.returnClothingTracker`
2. Download `GoogleService-Info.plist`
3. Place it in `ios/Runner/`

### 4. Enable Authentication Providers
In Firebase Console > Authentication > Sign-in method:
- Enable Email/Password
- Enable Google Sign-In
- Enable Apple Sign-In (iOS only)

## 🗄️ Supabase Setup

### 1. Create Supabase Project
1. Go to [Supabase](https://supabase.com/)
2. Create a new project
3. Note your project URL and anon key

### 2. Database Schema
Run the following SQL in your Supabase SQL editor:

```sql
-- Enable Row Level Security
ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

-- Create users table
CREATE TABLE users (
    id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    first_name TEXT,
    last_name TEXT,
    avatar_url TEXT,
    preferences JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create stores table
CREATE TABLE stores (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL,
    logo_url TEXT,
    default_return_policy_days INTEGER NOT NULL DEFAULT 30,
    website TEXT,
    customer_service_phone TEXT,
    customer_service_email TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create return_items table
CREATE TABLE return_items (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    store_id UUID REFERENCES stores(id) NOT NULL,
    barcode TEXT,
    item_name TEXT NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    currency TEXT NOT NULL DEFAULT 'USD',
    purchase_date DATE NOT NULL,
    return_deadline DATE NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'expired', 'processing')),
    receipt_image_url TEXT,
    item_image_url TEXT,
    tags TEXT[],
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create store_locations table
CREATE TABLE store_locations (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    store_id UUID REFERENCES stores(id) ON DELETE CASCADE NOT NULL,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    city TEXT,
    state TEXT,
    zip_code TEXT,
    country TEXT,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    phone_number TEXT,
    opening_hours JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX idx_return_items_user_id ON return_items(user_id);
CREATE INDEX idx_return_items_status ON return_items(status);
CREATE INDEX idx_return_items_deadline ON return_items(return_deadline);
CREATE INDEX idx_store_locations_store_id ON store_locations(store_id);

-- Enable RLS policies
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE return_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE store_locations ENABLE ROW LEVEL SECURITY;

-- Users can only access their own data
CREATE POLICY "Users can view own profile" ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON users FOR UPDATE USING (auth.uid() = id);

-- Users can only access their own return items
CREATE POLICY "Users can view own return items" ON return_items FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own return items" ON return_items FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own return items" ON return_items FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own return items" ON return_items FOR DELETE USING (auth.uid() = user_id);

-- Stores and store locations are publicly readable
CREATE POLICY "Stores are publicly readable" ON stores FOR SELECT USING (true);
CREATE POLICY "Store locations are publicly readable" ON store_locations FOR SELECT USING (true);
```

### 3. Insert Sample Store Data
```sql
-- Insert popular stores
INSERT INTO stores (name, default_return_policy_days, website) VALUES
('H&M', 30, 'https://www.hm.com'),
('Zara', 30, 'https://www.zara.com'),
('Uniqlo', 30, 'https://www.uniqlo.com'),
('Nike', 30, 'https://www.nike.com'),
('Adidas', 30, 'https://www.adidas.com'),
('Amazon', 30, 'https://www.amazon.com'),
('Target', 90, 'https://www.target.com'),
('Walmart', 90, 'https://www.walmart.com'),
('Costco', 90, 'https://www.costco.com');
```

## 📱 Platform Configuration

### Android Configuration

1. Update `android/app/build.gradle`:
```gradle
android {
    compileSdkVersion 34
    ndkVersion flutter.ndkVersion

    defaultConfig {
        applicationId "com.returntracker.return_clothing_tracker"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
}
```

2. Add permissions in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.USE_BIOMETRIC" />
<uses-permission android:name="android.permission.USE_FINGERPRINT" />
```

### iOS Configuration

1. Update `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs access to camera to scan barcodes and take photos of receipts.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to photo library to save and retrieve receipt images.</string>
<key>NSFaceIDUsageDescription</key>
<string>This app uses Face ID for secure authentication.</string>
```

2. Set minimum iOS version in `ios/Podfile`:
```ruby
platform :ios, '12.0'
```

## 🧪 Testing Setup

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Test Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🚀 Build and Deployment

### Development Build
```bash
flutter run --debug
```

### Production Build

#### Android
```bash
# APK
flutter build apk --release

# App Bundle (recommended for Play Store)
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

## 🔧 Troubleshooting

### Common Issues

1. **Dependency conflicts**: Run `flutter clean && flutter pub get`
2. **iOS build issues**: Run `cd ios && pod install`
3. **Android build issues**: Sync project in Android Studio
4. **Firebase not working**: Check `google-services.json` and `GoogleService-Info.plist` placement

### Performance Issues
- Enable release mode for testing: `flutter run --release`
- Profile app performance: `flutter run --profile`

### Debug Options
- Enable debug logging in development
- Use Flutter Inspector for UI debugging
- Monitor network requests in development

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Flutter Setup](https://firebase.google.com/docs/flutter/setup)
- [Supabase Flutter Guide](https://supabase.com/docs/guides/getting-started/tutorials/with-flutter)
- [Material Design 3](https://m3.material.io/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Write/update tests
5. Submit a pull request

For more details, see [CONTRIBUTING.md](CONTRIBUTING.md).

## 📝 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) for details. 