import 'package:clinic_appointment_system/core/constants/working_hours_constants.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:flutter/material.dart';

/// Presents the shared 24-hour time picker.
extension ClockTimePicking on BuildContext {
  /// Returns the selected time, or null when the picker is dismissed.
  Future<ClockTime?> pickClockTime({ClockTime? initial}) async {
    final time =
        initial ??
        ClockTime(
          hour: WorkingHoursConstants.openingHour,
          minute: WorkingHoursConstants.openingMinute,
        );
    final selected = await showTimePicker(
      context: this,
      initialTime: TimeOfDay(hour: time.hour, minute: time.minute),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (selected == null) return null;
    return ClockTime(hour: selected.hour, minute: selected.minute);
  }
}
