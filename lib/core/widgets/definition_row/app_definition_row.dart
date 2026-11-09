import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

/// A muted term above its value, as in details dialogs and summaries.
final class AppDefinitionRow extends StatelessWidget {
  /// Creates a definition row showing [label] above [child].
  const AppDefinitionRow({required this.label, required this.child, super.key});

  /// The term naming the value.
  final String label;

  /// The value, usually strong body text or a badge.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSizes.s4,
      children: [
        AppText.caption(label, tone: TextTone.muted),
        child,
      ],
    );
  }
}
