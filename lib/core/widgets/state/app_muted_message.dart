import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

/// A centered, subdued message for a section.
final class AppMutedMessage extends StatelessWidget {
  /// Creates a muted message.
  const AppMutedMessage({required this.message, super.key});

  /// Message displayed in the section.
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const AppPadding.allXl(),
        child: AppText.body(message, tone: TextTone.muted),
      ),
    );
  }
}
