import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/time_range_chip/app_time_range_chip_variant.dart';
import 'package:flutter/material.dart';

/// Resolves range chip colors, text tone and semantics from the variant.
extension AppTimeRangeChipVariantColors on AppTimeRangeChipVariant {
  Color background(ColorScheme scheme) => switch (this) {
    AppTimeRangeChipVariant.standard => scheme.primaryContainer,
    AppTimeRangeChipVariant.flagged => scheme.errorContainer,
  };
  Color foreground(ColorScheme scheme) => switch (this) {
    AppTimeRangeChipVariant.standard => scheme.onPrimaryContainer,
    AppTimeRangeChipVariant.flagged => scheme.onErrorContainer,
  };
  TextTone get tone => switch (this) {
    AppTimeRangeChipVariant.standard => TextTone.onPrimaryContainer,
    AppTimeRangeChipVariant.flagged => TextTone.onErrorContainer,
  };

  /// Extra screen-reader hint, or null when the range needs none.
  String? get semanticsHint => switch (this) {
    AppTimeRangeChipVariant.standard => null,
    AppTimeRangeChipVariant.flagged =>
      LocaleKeys.common_rangeOutsideHours.translate(),
  };
}
