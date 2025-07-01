# Return Clothing Tracker

A mobile app that helps users manage their retail returns efficiently and never miss a deadline.

## 🚀 Features

### Core Features
- **Item Management**: Add, edit, and track clothing items with return deadlines
- **Barcode Scanning**: Quick item entry using mobile barcode scanner
- **Smart Notifications**: Configurable reminders (14, 7, 3, 1 days before deadline)
- **Visual Dashboard**: Overview of pending, completed, and urgent returns
- **Calendar Integration**: Monthly/weekly views with deadline indicators
- **Receipt Management**: Upload and store receipt images
- **Store Database**: Pre-configured return policies for major retailers

### Authentication & Security
- Email/password and social login (Google, Apple)
- Secure token management and session persistence
- Biometric authentication support
- Profile management with avatars

### Data & Sync
- Offline support with local storage (Hive)
- Real-time sync with Supabase backend
- Export to PDF reports and CSV data
- Cloud backup and restore functionality

### UI/UX
- Material Design 3 implementation
- Dark and light theme support
- Responsive design for all screen sizes
- Accessibility features (screen reader, dynamic text)
- Smooth animations and transitions

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                   # Core utilities and configurations
│   ├── constants/         # App constants and configuration
│   ├── errors/           # Error handling and failures
│   ├── network/          # Network utilities
│   ├── theme/            # Material Design 3 theme
│   └── utils/            # Helper utilities
├── data/                  # Data layer
│   ├── datasources/      # Local and remote data sources
│   ├── models/           # Data models and DTOs
│   └── repositories/     # Repository implementations
├── domain/               # Business logic layer
│   ├── entities/         # Domain entities
│   ├── repositories/     # Repository interfaces
│   └── usecases/         # Business use cases
└── presentation/         # UI layer
    ├── pages/            # Screen widgets
    ├── widgets/          # Reusable UI components
    └── providers/        # State management (Riverpod)
```

## 🛠️ Tech Stack

### Framework & Language
- **Flutter** (Latest stable SDK)
- **Dart** programming language

### State Management
- **Riverpod** for reactive state management
- **Riverpod Generator** for code generation

### Backend & Database
- **Supabase** for backend services and real-time features
- **Hive** for local storage and offline support

### Authentication
- **Firebase Auth** with email/password and social providers
- **Google Sign-In** and **Sign in with Apple**

### Features & Services
- **Mobile Scanner** for barcode scanning
- **Firebase Cloud Messaging** for push notifications
- **Image Picker** for camera and gallery access
- **Permission Handler** for device permissions

### UI & Design
- **Material Design 3** components and theming
- **Flutter Animate** for smooth animations
- **Cached Network Image** for optimized image loading
- **Shimmer** for loading placeholders

### Development Tools
- **Auto Route** for navigation and routing
- **Build Runner** for code generation
- **Flutter Lints** for code quality
- **Mockito** for unit testing

## 📱 Screenshots

> Screenshots will be added here once the app is fully implemented

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio or VS Code
- iOS development setup (for iOS deployment)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/return_clothing_tracker.git
   cd return_clothing_tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   Create a `.env` file in the root directory:
   ```env
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

4. **Configure Firebase**
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Follow Firebase setup instructions for Flutter

5. **Set up Supabase**
   - Create a Supabase project
   - Set up authentication providers
   - Create database tables (schema provided in `/sql` directory)

6. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

#### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

## 🧪 Testing

### Run Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Widget tests
flutter test test/widget_test/
```

### Test Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 📊 Database Schema

### Tables

**users**
```sql
- id: uuid (primary key)
- email: text (unique)
- first_name: text
- last_name: text
- avatar_url: text
- preferences: jsonb
- created_at: timestamp
- updated_at: timestamp
```

**stores**
```sql
- id: uuid (primary key)
- name: text
- logo_url: text
- default_return_policy_days: integer
- website: text
- customer_service_phone: text
- customer_service_email: text
- created_at: timestamp
- updated_at: timestamp
```

**return_items**
```sql
- id: uuid (primary key)
- user_id: uuid (foreign key)
- store_id: uuid (foreign key)
- barcode: text
- item_name: text
- description: text
- price: decimal
- currency: text
- purchase_date: date
- return_deadline: date
- status: enum (pending, completed, expired, processing)
- receipt_image_url: text
- item_image_url: text
- tags: text[]
- notes: text
- created_at: timestamp
- updated_at: timestamp
```

## 🔔 Notifications

The app implements smart notifications with multiple channels:

- **General Notifications**: App updates and announcements
- **Return Reminders**: Deadline-based reminders
- **Urgent Reminders**: High-priority alerts for items due soon

### Notification Schedule
- 14 days before deadline
- 7 days before deadline  
- 3 days before deadline
- 1 day before deadline
- Day of deadline

## 🎨 Design System

### Colors
- **Primary**: Purple-based Material You color palette
- **Secondary**: Complementary accent colors
- **Status Colors**: 
  - Success: Green
  - Warning: Orange
  - Error: Red
  - Pending: Blue

### Typography
- **Font Family**: Inter (Google Fonts)
- **Scales**: Material Design 3 type scale
- **Weights**: Regular (400), Medium (500), Semi-Bold (600), Bold (700)

### Components
- Material Design 3 components
- Custom widgets for app-specific needs
- Consistent spacing and layout patterns

## 🚀 Deployment

### App Store Guidelines
- Follow platform-specific guidelines
- Include required privacy policy
- Set up app store optimization (ASO)

### CI/CD Pipeline
The project includes GitHub Actions workflows for:
- Automated testing
- Code quality checks
- Build automation
- Deployment to app stores

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow Dart/Flutter conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Write tests for new features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/your-username/return_clothing_tracker/issues) page
2. Create a new issue with detailed description
3. Join our [Discord community](https://discord.gg/your-invite) for support

## 📞 Contact

- **Developer**: Your Name
- **Email**: your.email@example.com
- **Website**: [your-website.com](https://your-website.com)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for the design system
- Supabase for the backend infrastructure
- All contributors who helped make this project better

---

**Made with ❤️ using Flutter**
