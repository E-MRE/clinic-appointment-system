import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/features/availability/presentation/enums/availability_timeline_bar_variant.dart';
import 'package:flutter/material.dart';

/// Resolves bar fill and text from the active theme without embedding a palette.
extension AvailabilityTimelineBarVariantColors
    on AvailabilityTimelineBarVariant {
  /// Background color of the bar.
  Color background(ColorScheme colors) => switch (this) {
    AvailabilityTimelineBarVariant.saved => colors.primary,
    AvailabilityTimelineBarVariant.flagged => colors.error,
    AvailabilityTimelineBarVariant.pending => colors.primaryContainer,
  };

  /// Dashed outline for a pending range; persisted bars have no outline.
  BorderSide? border(ColorScheme colors) => switch (this) {
    AvailabilityTimelineBarVariant.pending => BorderSide(
      color: colors.primary,
      width: AppSizes.borderThick,
    ),
    _ => null,
  };

  /// Semantic text color used by the shared text component.
  TextTone get tone => switch (this) {
    AvailabilityTimelineBarVariant.saved => TextTone.onPrimary,
    AvailabilityTimelineBarVariant.flagged => TextTone.onError,
    AvailabilityTimelineBarVariant.pending => TextTone.onPrimaryContainer,
  };
}
