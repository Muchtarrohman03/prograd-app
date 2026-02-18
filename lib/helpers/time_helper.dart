import 'package:flutter/material.dart';

class TimeHelper {
  /// Parse "HH:mm" → TimeOfDay?
  static TimeOfDay? parseNullable(String? time) {
    if (time == null || time.trim().isEmpty) return null;

    final parts = time.split(':');
    if (parts.length != 2) return null;

    final hour = int.tryParse(parts[0].trim());
    final minute = int.tryParse(parts[1].trim());

    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23) return null;
    if (minute < 0 || minute > 59) return null;

    return TimeOfDay(hour: hour, minute: minute);
  }

  /// TimeOfDay → "HH:mm"
  static String? format(TimeOfDay? time) {
    if (time == null) return null;
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Safe formatter for DB (never null)
  static String formatOrZero(TimeOfDay? time) {
    return format(time) ?? '00:00';
  }

  /// Default time
  static TimeOfDay fallback() => const TimeOfDay(hour: 0, minute: 0);
}
