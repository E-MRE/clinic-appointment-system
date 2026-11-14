import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_variant.dart';
import 'package:flutter/material.dart';

/// Theme colors of an [AppSurfaceVariant].
extension AppSurfaceVariantColors on AppSurfaceVariant {
  /// Fill color of the surface.
  Color background(BuildContext context) {
    final colors = context.colorScheme;
    return switch (this) {
      AppSurfaceVariant.standard => colors.surfaceContainerLow,
      AppSurfaceVariant.plain => colors.surface,
      AppSurfaceVariant.highlighted => colors.primaryContainer,
      AppSurfaceVariant.pending => context.statusColors.pendingBg,
    };
  }

  /// Border color of the surface.
  Color border(BuildContext context) {
    final colors = context.colorScheme;
    return switch (this) {
      AppSurfaceVariant.standard ||
      AppSurfaceVariant.plain => colors.outlineVariant,
      AppSurfaceVariant.highlighted => colors.primary,
      AppSurfaceVariant.pending => context.statusColors.pendingBg,
    };
  }
}
