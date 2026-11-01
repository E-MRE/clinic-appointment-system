import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

part 'app_picker_field_control.dart';

/// Shared presentation for a labeled date or time picker.
final class AppPickerField extends StatelessWidget {
  /// Creates a picker control with the supplied display value and action.
  const AppPickerField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    required this.enabled,
    this.hasError = false,
    this.isHint = false,
    this.fieldKey,
    super.key,
  });
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;
  final bool hasError;
  final bool isHint;
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExcludeSemantics(child: AppText.label(label)),
        const EmptySize.s8Height(),
        _AppPickerFieldControl(field: this),
      ],
    );
  }
}
