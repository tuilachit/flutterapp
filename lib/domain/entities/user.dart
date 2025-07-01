class User {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserPreferences preferences;

  const User({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.preferences,
  });

  String get displayName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    }
    return email.split('@').first;
  }

  String get fullName => displayName;

  // JSON serialization for Supabase
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'preferences': preferences.toJson(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserPreferences? preferences,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.avatarUrl == avatarUrl &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.preferences == preferences;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        avatarUrl.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        preferences.hashCode;
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, firstName: $firstName, lastName: $lastName)';
  }
}

class UserPreferences {
  final String currency;
  final String dateFormat;
  final bool enableNotifications;
  final List<int> reminderDays;
  final String defaultView; // 'grid' or 'list'
  final bool enableBiometric;
  final String theme; // 'light', 'dark', 'system'

  const UserPreferences({
    required this.currency,
    required this.dateFormat,
    required this.enableNotifications,
    required this.reminderDays,
    required this.defaultView,
    required this.enableBiometric,
    required this.theme,
  });

  // JSON serialization for Supabase
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      currency: json['currency'] as String? ?? 'USD',
      dateFormat: json['date_format'] as String? ?? 'dd/MM/yyyy',
      enableNotifications: json['enable_notifications'] as bool? ?? true,
      reminderDays: (json['reminder_days'] as List<dynamic>?)?.cast<int>() ??
          [14, 7, 3, 1],
      defaultView: json['default_view'] as String? ?? 'grid',
      enableBiometric: json['enable_biometric'] as bool? ?? false,
      theme: json['theme'] as String? ?? 'system',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'date_format': dateFormat,
      'enable_notifications': enableNotifications,
      'reminder_days': reminderDays,
      'default_view': defaultView,
      'enable_biometric': enableBiometric,
      'theme': theme,
    };
  }

  UserPreferences copyWith({
    String? currency,
    String? dateFormat,
    bool? enableNotifications,
    List<int>? reminderDays,
    String? defaultView,
    bool? enableBiometric,
    String? theme,
  }) {
    return UserPreferences(
      currency: currency ?? this.currency,
      dateFormat: dateFormat ?? this.dateFormat,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      reminderDays: reminderDays ?? this.reminderDays,
      defaultView: defaultView ?? this.defaultView,
      enableBiometric: enableBiometric ?? this.enableBiometric,
      theme: theme ?? this.theme,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserPreferences &&
        other.currency == currency &&
        other.dateFormat == dateFormat &&
        other.enableNotifications == enableNotifications &&
        _listEquals(other.reminderDays, reminderDays) &&
        other.defaultView == defaultView &&
        other.enableBiometric == enableBiometric &&
        other.theme == theme;
  }

  @override
  int get hashCode {
    return currency.hashCode ^
        dateFormat.hashCode ^
        enableNotifications.hashCode ^
        reminderDays.hashCode ^
        defaultView.hashCode ^
        enableBiometric.hashCode ^
        theme.hashCode;
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'UserPreferences(currency: $currency, enableNotifications: $enableNotifications)';
  }
}
