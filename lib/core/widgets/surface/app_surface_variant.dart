import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:flutter/material.dart';

/// Shape and emphasis options for [AppSurface].
enum AppSurfaceVariant {
  /// Standard surface using the low surface container.
  standard(borderWidth: AppSizes.borderThin),

  /// Highlighted surface using the primary container.
  highlighted(borderWidth: AppSizes.borderThick);

  const AppSurfaceVariant({required this.borderWidth});

  /// Width of the surface border.
  final double borderWidth;

  /// Fill color of the surface.
  Color background(ColorScheme colors) {
    return switch (this) {
      AppSurfaceVariant.standard => colors.surfaceContainerLow,
      AppSurfaceVariant.highlighted => colors.primaryContainer,
    };
  }

  /// Border color of the surface.
  Color border(ColorScheme colors) {
    return switch (this) {
      AppSurfaceVariant.standard => colors.outlineVariant,
      AppSurfaceVariant.highlighted => colors.primary,
    };
  }
}
