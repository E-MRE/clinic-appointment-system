import 'package:flutter/material.dart';

/// Data for one destination in a responsive navigation shell.
final class AppNavigationDestination {
  /// Creates a destination from display text and icon variants.
  const AppNavigationDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.badgeCount,
  });

  /// Visible destination label.
  final String label;

  /// Icon used when this destination is not selected.
  final IconData icon;

  /// Icon used when this destination is selected.
  final IconData selectedIcon;

  /// Optional count displayed with the destination.
  final int? badgeCount;
}
