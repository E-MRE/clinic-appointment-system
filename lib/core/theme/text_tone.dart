import 'package:flutter/material.dart';

/// Semantic foreground colors available to application text.
enum TextTone {
  /// Main foreground with the highest contrast on a surface.
  normal,

  /// Secondary foreground for supporting content.
  muted,

  /// Primary brand accent.
  primary,

  /// Foreground for a primary-colored surface.
  onPrimary,

  /// Foreground for a primary container.
  onPrimaryContainer,

  /// Foreground for a secondary container.
  onSecondaryContainer,

  /// Foreground for a tertiary container.
  onTertiaryContainer,

  /// Error foreground.
  error,

  /// Foreground for an error-colored surface.
  onError,

  /// Foreground for an error container.
  onErrorContainer,

  /// Foreground for an inverse surface.
  onInverse,

  /// Foreground for the application's splash and brand surfaces.
  onBrand;

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
