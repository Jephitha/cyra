import 'package:flutter/material.dart';

extension DateTimeX on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  int daysUntil(DateTime other) => other.startOfDay.difference(startOfDay).inDays;

  int dayOfCycle(DateTime cycleStart) {
    final diff = startOfDay.difference(cycleStart.startOfDay).inDays;
    return diff < 0 ? 0 : diff + 1;
  }
}

extension StringX on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String sanitizeFileName() =>
      replaceAll(RegExp(r'[^\w\-_. ]'), '_').replaceAll(RegExp(r'\s+'), '_');
}

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  double get screenWidth => mediaQuery.size.width;

  double get screenHeight => mediaQuery.size.height;

  bool get isSmallScreen => screenWidth < 360;

  bool get isTablet => screenWidth >= 600;

  void showSnackBar(
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
          backgroundColor: isError
              ? Theme.of(this).colorScheme.error
              : null,
        ),
      );
  }
}

extension NumX on num {
  String toTemperatureString() => '${toStringAsFixed(1)}°';
}
