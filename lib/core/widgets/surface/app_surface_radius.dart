import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:flutter/material.dart';

/// Preset corner radii for a card or panel surface.
enum AppSurfaceRadius {
  /// Card radius = 12.
  card(AppRadius.medium()),

  /// Panel radius = 16.
  panel(AppRadius.large());

  const AppSurfaceRadius(this.value);

  /// Radius used by this surface.
  final BorderRadius value;
}
