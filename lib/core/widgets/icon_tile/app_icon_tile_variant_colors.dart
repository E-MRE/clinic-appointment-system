import 'package:clinic_appointment_system/core/widgets/icon_tile/app_icon_tile_variant.dart';
import 'package:flutter/material.dart';

/// Theme colors of an [AppIconTileVariant].
extension AppIconTileVariantColors on AppIconTileVariant {
  /// Fill color of the tile.
  Color background(ColorScheme colors) {
    return switch (this) {
      AppIconTileVariant.secondary => colors.secondaryContainer,
      AppIconTileVariant.tertiary => colors.tertiaryContainer,
    };
  }

  /// Icon color on the tile.
  Color foreground(ColorScheme colors) {
    return switch (this) {
      AppIconTileVariant.secondary => colors.onSecondaryContainer,
      AppIconTileVariant.tertiary => colors.onTertiaryContainer,
    };
  }
}
