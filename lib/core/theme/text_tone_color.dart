import 'package:clinic_appointment_system/core/theme/text_tone.dart';
import 'package:flutter/material.dart';

/// Resolves a [TextTone] to a color of the active theme.
extension TextToneColor on TextTone {
  /// Resolves this tone from the active [ColorScheme] and brand foreground.
  Color resolve(ColorScheme colorScheme, {required Color brandForeground}) {
    return switch (this) {
      TextTone.normal => colorScheme.onSurface,
      TextTone.muted => colorScheme.onSurfaceVariant,
      TextTone.primary => colorScheme.primary,
      TextTone.onPrimary => colorScheme.onPrimary,
      TextTone.onPrimaryContainer => colorScheme.onPrimaryContainer,
      TextTone.onSecondaryContainer => colorScheme.onSecondaryContainer,
      TextTone.onTertiaryContainer => colorScheme.onTertiaryContainer,
      TextTone.error => colorScheme.error,
      TextTone.onError => colorScheme.onError,
      TextTone.onErrorContainer => colorScheme.onErrorContainer,
      TextTone.onInverse => colorScheme.onInverseSurface,
      TextTone.onBrand => brandForeground,
    };
  }
}
