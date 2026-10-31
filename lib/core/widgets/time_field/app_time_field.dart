import 'package:clinic_appointment_system/core/extensions/clock_time_picking.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/widgets/time_field/app_picker_field.dart';
import 'package:flutter/material.dart';

/// Labeled field that selects a 24-hour time.
final class AppTimeField extends StatelessWidget {
  /// Creates a time picker field.
  const AppTimeField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.hint,
    this.hasError = false,
    this.enabled = true,
    this.fieldKey,
    super.key,
  });
  final String label;
  final ClockTime? value;
  final ValueChanged<ClockTime> onChanged;
  final String? hint;
  final bool hasError;
  final bool enabled;
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    return AppPickerField(
      label: label,
      value: value?.toString() ?? hint ?? '',
      icon: Icons.access_time,
      enabled: enabled,
      hasError: hasError,
      isHint: value == null,
      fieldKey: fieldKey,
      onTap: () async {
        final selected = await context.pickClockTime(initial: value);
        if (selected != null && context.mounted) onChanged(selected);
      },
    );
  }
}
