import 'package:clinic_appointment_system/core/widgets/surface/app_surface_variant.dart';
import 'package:flutter/material.dart';

/// Theme colors of an [AppSurfaceVariant].
extension AppSurfaceVariantColors on AppSurfaceVariant {
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
