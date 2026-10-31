import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

/// Filled action for adding an item.
final class AppAddButton extends StatelessWidget {
  /// Creates an add action.
  const AppAddButton({required this.label, this.onPressed, super.key});

  /// Action label.
  final String label;

  /// Called when pressed, or null to disable the action.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add),
      label: AppText.label(label, tone: TextTone.onPrimary),
    );
  }
}
