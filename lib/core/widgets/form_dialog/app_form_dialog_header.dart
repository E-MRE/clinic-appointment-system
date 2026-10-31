import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

/// Heading and close action for a form dialog.
final class AppFormDialogHeader extends StatelessWidget {
  /// Creates the dialog heading.
  const AppFormDialogHeader({required this.title, super.key});

  /// Heading displayed in the dialog.
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: AppText.sectionTitle(title)),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
