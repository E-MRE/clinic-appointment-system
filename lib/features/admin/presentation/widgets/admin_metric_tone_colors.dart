import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_variant.dart';
import 'package:clinic_appointment_system/features/admin/presentation/widgets/admin_metric_tone.dart';
import 'package:flutter/material.dart';

/// Resolves overview metric tones against the active theme.
extension AdminMetricToneColors on AdminMetricTone {
  /// The shared surface treatment for this metric.
  AppSurfaceVariant get surfaceVariant {
    return switch (this) {
      AdminMetricTone.primary => AppSurfaceVariant.highlighted,
      AdminMetricTone.pending => AppSurfaceVariant.pending,
      AdminMetricTone.neutral => AppSurfaceVariant.standard,
    };
  }

  /// The title and value color for this metric.
  Color foreground(BuildContext context) {
    return switch (this) {
      AdminMetricTone.primary => context.colorScheme.onPrimaryContainer,
      AdminMetricTone.pending => context.statusColors.pendingFg,
      AdminMetricTone.neutral => context.colorScheme.onSurface,
    };
  }

  /// The subdued caption color for this metric.
  Color captionColor(BuildContext context) {
    return switch (this) {
      AdminMetricTone.primary => context.colorScheme.onPrimaryContainer,
      AdminMetricTone.pending => context.statusColors.pendingFg,
      AdminMetricTone.neutral => context.colorScheme.onSurfaceVariant,
    };
  }
}
