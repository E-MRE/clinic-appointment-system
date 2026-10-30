import 'package:clinic_appointment_system/core/theme/text_role.dart';
import 'package:flutter/material.dart';

/// Resolves a [TextRole] to a style of the active text theme.
extension TextRoleStyle on TextRole {
  /// Resolves this role to its configured text style.
  TextStyle? resolve(TextTheme textTheme) {
    return switch (this) {
      TextRole.display => textTheme.displaySmall,
      TextRole.headline => textTheme.headlineMedium,
      TextRole.pageTitle => textTheme.headlineSmall,
      TextRole.sectionTitle => textTheme.titleLarge,
      TextRole.cardTitle => textTheme.titleMedium,
      TextRole.bodyLarge => textTheme.bodyLarge,
      TextRole.body => textTheme.bodyMedium,
      TextRole.caption => textTheme.bodySmall,
      TextRole.bodyStrong => textTheme.labelLarge,
      TextRole.label => textTheme.labelMedium,
      TextRole.badge => textTheme.labelSmall,
    };
  }
}
