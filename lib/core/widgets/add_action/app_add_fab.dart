import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

/// Extended floating action for adding an item.
final class AppAddFab extends StatelessWidget {
  /// Creates a floating add action.
  const AppAddFab({required this.label, required this.onPressed, super.key});

  /// Action label.
  final String label;

  /// Called when pressed.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: const Icon(Icons.add),
      label: AppText.label(label, tone: TextTone.onPrimary),
      backgroundColor: context.colorScheme.primary,
      foregroundColor: context.colorScheme.onPrimary,
    );
  }
}
