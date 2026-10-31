import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:flutter/material.dart';

/// Presents the shared calendar date picker.
extension CalendarDatePicking on BuildContext {
  /// Returns the selected date, or null when dismissed.
  Future<CalendarDate?> pickCalendarDate({
    required CalendarDate initial,
    required CalendarDate first,
    required CalendarDate last,
  }) async {
    final selected = await showDatePicker(
      context: this,
      initialDate: DateTime(initial.year, initial.month, initial.day),
      firstDate: DateTime(first.year, first.month, first.day),
      lastDate: DateTime(last.year, last.month, last.day),
    );
    if (selected == null) return null;
    return CalendarDate.fromDateTime(selected);
  }
}
