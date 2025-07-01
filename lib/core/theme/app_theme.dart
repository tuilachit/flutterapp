import 'package:flutter/material.dart';

/// Trust-building Material Design 3 theme for ReturnPal app
/// Uses blue as primary (trust, security) and green as secondary (success, safety)
class AppTheme {
  // Trust-building Color Palette
  static const Color _primaryBlue = Color(0xFF1976D2); // Trust, security, calm
  static const Color _primaryBlueLight = Color(0xFF42A5F5);
  static const Color _primaryBlueDark = Color(0xFF1565C0);

  static const Color _secondaryGreen = Color(0xFF4CAF50); // Success, safety
  static const Color _secondaryGreenLight = Color(0xFF66BB6A);
  static const Color _secondaryGreenDark = Color(0xFF388E3C);

  static const Color _tertiaryOrange = Color(0xFFFF9800); // Warning, attention
  static const Color _tertiaryOrangeLight = Color(0xFFFFB74D);
  static const Color _tertiaryOrangeDark = Color(0xFFF57C00);

  static const Color _errorRed = Color(0xFFD32F2F); // Error, danger
  static const Color _errorRedLight = Color(0xFFEF5350);
  static const Color _errorRedDark = Color(0xFFC62828);

  static const Color _neutralGray = Color(0xFF757575); // Neutral, balanced
  static const Color _neutralGrayLight = Color(0xFF9E9E9E);
  static const Color _neutralGrayDark = Color(0xFF424242);

  static const Color _surfaceWhite = Color(0xFFFFFFFF);
  static const Color _surfaceGray = Color(0xFFFAFAFA);
  static const Color _surfaceGrayDark = Color(0xFFF5F5F5);

  static const Color _onSurfaceDark = Color(0xFF212121);
  static const Color _onSurfaceMedium = Color(0xFF616161);
  static const Color _onSurfaceLight = Color(0xFF9E9E9E);

  // Legacy color support (for existing components)
  static const Color primaryPurple = _primaryBlue;
  static const Color secondaryPurple = _secondaryGreen;
  static const Color lightPurple = _primaryBlueLight;
  static const Color darkPurple = _primaryBlueDark;
  static const Color successColor = _secondaryGreen;
  static const Color warningColor = _tertiaryOrange;
  static const Color errorColor = _errorRed;
  static const Color infoColor = _primaryBlue;
  static const Color backgroundColor = _surfaceGray;
  static const Color surfaceColor = _surfaceWhite;
  static const Color cardColor = _surfaceWhite;
  static const Color primaryTextColor = _onSurfaceDark;
  static const Color secondaryTextColor = _onSurfaceMedium;
  static const Color lightTextColor = _onSurfaceLight;

  // Gradient Definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      _primaryBlue,
      _primaryBlueLight,
      _secondaryGreen,
    ],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      _secondaryGreen,
      _secondaryGreenLight,
    ],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      _tertiaryOrange,
      _tertiaryOrangeLight,
    ],
  );

  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      _errorRed,
      _errorRedLight,
    ],
  );

  /// Material Design 3 Light Theme with trust-building colors and dynamic color support
  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryBlue,
      brightness: Brightness.light,
      secondary: _secondaryGreen,
      tertiary: _tertiaryOrange,
      error: _errorRed,
      surface: _surfaceWhite,
      onPrimary: _surfaceWhite,
      onSecondary: _surfaceWhite,
      onTertiary: _surfaceWhite,
      onError: _surfaceWhite,
      onSurface: _onSurfaceDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'SF Pro Display',
      scaffoldBackgroundColor: colorScheme.surface,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          fontFamily: 'SF Pro Display',
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: 24,
        ),
        actionsIconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: 20,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: _surfaceWhite,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2,
          shadowColor: colorScheme.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Display',
          ),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Display',
          ),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Display',
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _neutralGrayLight.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _neutralGrayLight.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        filled: true,
        fillColor: _surfaceWhite,
        contentPadding: const EdgeInsets.all(16),
        labelStyle: TextStyle(
          color: _onSurfaceMedium,
          fontFamily: 'SF Pro Display',
          fontSize: 16,
        ),
        hintStyle: TextStyle(
          color: _onSurfaceLight,
          fontFamily: 'SF Pro Display',
          fontSize: 16,
        ),
        errorStyle: TextStyle(
          color: colorScheme.error,
          fontFamily: 'SF Pro Display',
          fontSize: 12,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _surfaceWhite,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: _onSurfaceLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Display',
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontFamily: 'SF Pro Display',
          fontSize: 12,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.primary.withOpacity(0.1),
        selectedColor: colorScheme.primary,
        labelStyle: TextStyle(
          color: colorScheme.primary,
          fontFamily: 'SF Pro Display',
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 0,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: _neutralGrayLight.withOpacity(0.2),
        thickness: 1,
        space: 1,
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          fontFamily: 'SF Pro Display',
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 14,
          color: _onSurfaceMedium,
          fontFamily: 'SF Pro Display',
        ),
        leadingAndTrailingTextStyle: TextStyle(
          fontSize: 14,
          color: _onSurfaceMedium,
          fontFamily: 'SF Pro Display',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return _neutralGrayLight;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary.withOpacity(0.5);
          }
          return _neutralGrayLight.withOpacity(0.5);
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(colorScheme.onPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return _neutralGrayLight;
        }),
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: _neutralGrayLight.withOpacity(0.5),
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withOpacity(0.2),
        valueIndicatorColor: colorScheme.primary,
        valueIndicatorTextStyle: TextStyle(
          color: colorScheme.onPrimary,
          fontFamily: 'SF Pro Display',
          fontWeight: FontWeight.w600,
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: _neutralGrayLight.withOpacity(0.3),
        circularTrackColor: _neutralGrayLight.withOpacity(0.3),
      ),

      // Text Theme with proper hierarchy
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: colorScheme.onSurface,
          fontFamily: 'SF Pro Display',
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
          fontFamily: 'SF Pro Display',
          letterSpacing: -0.25,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          fontFamily: 'SF Pro Display',
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
          fontFamily: 'SF Pro Display',
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          fontFamily: 'SF Pro Display',
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          fontFamily: 'SF Pro Display',
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          fontFamily: 'SF Pro Display',
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
          fontFamily: 'SF Pro Display',
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _onSurfaceMedium,
          fontFamily: 'SF Pro Display',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
          fontFamily: 'SF Pro Display',
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _onSurfaceMedium,
          fontFamily: 'SF Pro Display',
          height: 1.4,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _onSurfaceLight,
          fontFamily: 'SF Pro Display',
          height: 1.3,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
          fontFamily: 'SF Pro Display',
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _onSurfaceMedium,
          fontFamily: 'SF Pro Display',
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: _onSurfaceLight,
          fontFamily: 'SF Pro Display',
        ),
      ),
    );
  }

  /// Material Design 3 Dark Theme
  static ThemeData get darkTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryBlue,
      brightness: Brightness.dark,
      secondary: _secondaryGreen,
      tertiary: _tertiaryOrange,
      error: _errorRed,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'SF Pro Display',
      brightness: Brightness.dark,
      scaffoldBackgroundColor: colorScheme.surface,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          fontFamily: 'SF Pro Display',
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: 24,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: colorScheme.surface,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2,
          shadowColor: colorScheme.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Display',
          ),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.all(16),
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontFamily: 'SF Pro Display',
          fontSize: 16,
        ),
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontFamily: 'SF Pro Display',
          fontSize: 16,
        ),
        errorStyle: TextStyle(
          color: colorScheme.error,
          fontFamily: 'SF Pro Display',
          fontSize: 12,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Display',
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontFamily: 'SF Pro Display',
          fontSize: 12,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: colorScheme.onSurface,
          fontFamily: 'SF Pro Display',
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
          fontFamily: 'SF Pro Display',
          letterSpacing: -0.25,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          fontFamily: 'SF Pro Display',
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
          fontFamily: 'SF Pro Display',
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          fontFamily: 'SF Pro Display',
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          fontFamily: 'SF Pro Display',
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          fontFamily: 'SF Pro Display',
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
          fontFamily: 'SF Pro Display',
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurfaceVariant,
          fontFamily: 'SF Pro Display',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
          fontFamily: 'SF Pro Display',
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurfaceVariant,
          fontFamily: 'SF Pro Display',
          height: 1.4,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurfaceVariant,
          fontFamily: 'SF Pro Display',
          height: 1.3,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
          fontFamily: 'SF Pro Display',
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurfaceVariant,
          fontFamily: 'SF Pro Display',
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurfaceVariant,
          fontFamily: 'SF Pro Display',
        ),
      ),
    );
  }

  /// Status colors for return items
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return _tertiaryOrange;
      case 'in_progress':
      case 'inprogress':
        return _primaryBlue;
      case 'completed':
        return _secondaryGreen;
      case 'expired':
        return _errorRed;
      default:
        return _neutralGray;
    }
  }

  /// Get status text for return items
  static String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'in_progress':
      case 'inprogress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'expired':
        return 'Expired';
      default:
        return 'Unknown';
    }
  }

  /// Get urgency color based on days remaining
  static Color getUrgencyColor(int daysRemaining) {
    if (daysRemaining <= 1) {
      return _errorRed;
    } else if (daysRemaining <= 3) {
      return _tertiaryOrange;
    } else if (daysRemaining <= 7) {
      return _primaryBlue;
    } else {
      return _secondaryGreen;
    }
  }

  /// Get urgency text based on days remaining
  static String getUrgencyText(int daysRemaining) {
    if (daysRemaining <= 1) {
      return 'Critical';
    } else if (daysRemaining <= 3) {
      return 'Urgent';
    } else if (daysRemaining <= 7) {
      return 'Due Soon';
    } else {
      return 'Safe';
    }
  }
}
