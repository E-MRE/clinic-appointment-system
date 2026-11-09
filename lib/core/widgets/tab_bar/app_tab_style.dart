import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:flutter/material.dart';

/// Visual values of a selected and an unselected tab.
enum AppTabStyle {
  /// Style for the active tab.
  selected(tone: TextTone.primary, weight: FontWeight.w600),

  /// Style for an inactive tab.
  unselected(tone: TextTone.muted, weight: FontWeight.w500);

  const AppTabStyle({required this.tone, required this.weight});

  /// Text tone for the tab label.
  final TextTone tone;

  /// Text weight for the tab label.
  final FontWeight weight;
}
