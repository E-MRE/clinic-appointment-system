import 'package:clinic_appointment_system/core/extensions/calendar_date_picking.dart';
import 'package:clinic_appointment_system/core/localization/app_formatters.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/widgets/time_field/app_picker_field.dart';
import 'package:flutter/material.dart';

/// Labeled field that selects a calendar date.
final class AppDateField extends StatelessWidget {
  /// Creates a date picker constrained to the supplied range.
  const AppDateField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.first,
    required this.last,
    this.enabled = true,
    this.fieldKey,
    super.key,
  });
  final String label;
  final CalendarDate value;
  final ValueChanged<CalendarDate> onChanged;
  final CalendarDate first;
  final CalendarDate last;
  final bool enabled;
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    return AppPickerField(
      label: label,
      value: AppFormatters.formatLongDate(
        DateTime(value.year, value.month, value.day),
        context: context,
      ),
      icon: Icons.calendar_today_outlined,
      enabled: enabled,
      fieldKey: fieldKey,
      onTap: () async {
        final selected = await context.pickCalendarDate(
          initial: value,
          first: first,
          last: last,
        );
        if (selected != null && context.mounted) onChanged(selected);
      },
    );
  }
}
