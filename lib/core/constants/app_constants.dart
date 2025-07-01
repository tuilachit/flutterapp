class AppConstants {
  // App Information
  static const String appName = 'Return Clothing Tracker';
  static const String appVersion = '1.0.0';

  // Supabase Configuration
  static const String supabaseUrl = 'https://wujxyoohgfaldeoyasasn.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind1anh5b29oZ2ZhbGRlb3lzYXNuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTEzNTAzNDIsImV4cCI6MjA2NjkyNjM0Mn0.2AyHRLp73kENGOwLYF-iq4WvDwTb4QqC7bsiiIuaJ-s';

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String settingsKey = 'app_settings';
  static const String notificationSettingsKey = 'notification_settings';

  // Notification Channels
  static const String generalChannelId = 'general_notifications';
  static const String reminderChannelId = 'return_reminders';
  static const String urgentChannelId = 'urgent_reminders';

  // Default Reminder Days
  static const List<int> defaultReminderDays = [14, 7, 3, 1];

  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  // Form Validation
  static const int maxDescriptionLength = 200;
  static const int minPasswordLength = 8;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Pagination
  static const int itemsPerPage = 20;

  // File Upload
  static const int maxImageSizeMB = 5;
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];

  // Return Policy Defaults (in days)
  static const Map<String, int> defaultReturnPolicies = {
    'H&M': 30,
    'Zara': 30,
    'Uniqlo': 30,
    'Nike': 30,
    'Adidas': 30,
    'Amazon': 30,
    'Target': 90,
    'Walmart': 90,
    'Costco': 90,
    'Other': 30,
  };

  // Currency Symbols
  static const Map<String, String> currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'CAD': 'C\$',
    'AUD': 'A\$',
  };

  // Error Messages
  static const String networkErrorMessage =
      'Network connection error. Please check your internet connection.';
  static const String genericErrorMessage =
      'Something went wrong. Please try again.';
  static const String authErrorMessage =
      'Authentication failed. Please sign in again.';
  static const String permissionDeniedMessage =
      'Permission denied. Please grant the required permissions.';
}
