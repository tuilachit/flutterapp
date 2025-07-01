import 'package:intl/intl.dart';

class AppDateUtils {
  // Private constructor to prevent instantiation
  AppDateUtils._();

  // Common date formats
  static const String standardDateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String shortDateFormat = 'dd MMM';
  static const String fullDateFormat = 'EEEE, dd MMMM yyyy';
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String apiDateTimeFormat = 'yyyy-MM-ddTHH:mm:ss.SSSZ';

  /// Format a DateTime to a standard date string
  static String formatDate(DateTime date, {String? format}) {
    final formatter = DateFormat(format ?? standardDateFormat);
    return formatter.format(date);
  }

  /// Format a DateTime to a standard date-time string
  static String formatDateTime(DateTime date, {String? format}) {
    final formatter = DateFormat(format ?? dateTimeFormat);
    return formatter.format(date);
  }

  /// Format date for API calls
  static String formatDateForApi(DateTime date) {
    final formatter = DateFormat(apiDateFormat);
    return formatter.format(date);
  }

  /// Format datetime for API calls
  static String formatDateTimeForApi(DateTime date) {
    final formatter = DateFormat(apiDateTimeFormat);
    return formatter.format(date.toUtc());
  }

  /// Parse date string from API
  static DateTime? parseDateFromApi(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Calculate return deadline based on purchase date and return policy days
  static DateTime calculateReturnDeadline(
      DateTime purchaseDate, int returnPolicyDays) {
    return purchaseDate.add(Duration(days: returnPolicyDays));
  }

  /// Get days remaining until deadline
  static int getDaysUntilDeadline(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now).inDays;
    return difference;
  }

  /// Check if a deadline is overdue
  static bool isOverdue(DateTime deadline) {
    final now = DateTime.now();
    return now.isAfter(deadline);
  }

  /// Check if a deadline is urgent (within specified days)
  static bool isUrgent(DateTime deadline, {int urgentThreshold = 3}) {
    final daysUntil = getDaysUntilDeadline(deadline);
    return daysUntil <= urgentThreshold && daysUntil >= 0;
  }

  /// Format relative date (e.g., "2 days ago", "Tomorrow", "Today")
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final compareDate = DateTime(date.year, date.month, date.day);
    final difference = compareDate.difference(today).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference > 1 && difference <= 7) {
      return 'In $difference days';
    } else if (difference < -1 && difference >= -7) {
      return '${difference.abs()} days ago';
    } else if (difference > 7) {
      return formatDate(date, format: shortDateFormat);
    } else {
      return formatDate(date, format: shortDateFormat);
    }
  }

  /// Format deadline status (e.g., "Due in 3 days", "Overdue by 2 days")
  static String formatDeadlineStatus(DateTime deadline) {
    final daysUntil = getDaysUntilDeadline(deadline);

    if (daysUntil == 0) {
      return 'Due today';
    } else if (daysUntil == 1) {
      return 'Due tomorrow';
    } else if (daysUntil > 1) {
      return 'Due in $daysUntil days';
    } else if (daysUntil == -1) {
      return 'Overdue by 1 day';
    } else {
      return 'Overdue by ${daysUntil.abs()} days';
    }
  }

  /// Get the start of the day for a given date
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get the end of the day for a given date
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get the start of the week (Monday) for a given date
  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysFromMonday)));
  }

  /// Get the end of the week (Sunday) for a given date
  static DateTime endOfWeek(DateTime date) {
    final daysUntilSunday = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: daysUntilSunday)));
  }

  /// Get the start of the month for a given date
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get the end of the month for a given date
  static DateTime endOfMonth(DateTime date) {
    final nextMonth = date.month == 12 ? 1 : date.month + 1;
    final nextYear = date.month == 12 ? date.year + 1 : date.year;
    return DateTime(nextYear, nextMonth, 1).subtract(const Duration(days: 1));
  }

  /// Check if two dates are on the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Get notification schedule dates for a deadline
  static List<DateTime> getNotificationSchedule(
      DateTime deadline, List<int> reminderDays) {
    final notifications = <DateTime>[];
    final now = DateTime.now();

    for (final days in reminderDays) {
      final notificationDate = deadline.subtract(Duration(days: days));
      if (notificationDate.isAfter(now)) {
        notifications.add(notificationDate);
      }
    }

    return notifications;
  }

  /// Format duration in a human-readable way
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays == 1 ? '' : 's'}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours == 1 ? '' : 's'}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minute${duration.inMinutes == 1 ? '' : 's'}';
    } else {
      return 'Less than a minute';
    }
  }

  /// Get month name from month number
  static String getMonthName(int month) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  /// Get abbreviated month name from month number
  static String getAbbreviatedMonthName(int month) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
