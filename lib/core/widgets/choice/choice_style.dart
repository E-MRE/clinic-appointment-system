import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:flutter/material.dart';

/// Visual values shared by segmented controls and filter chips.
enum ChoiceStyle {
  /// Style for the active choice.
  selected(tone: TextTone.onSecondaryContainer, weight: FontWeight.w600),

  /// Style for an inactive choice.
  unselected(tone: TextTone.normal, weight: FontWeight.w500);

  const ChoiceStyle({required this.tone, required this.weight});

  /// Text tone for the choice label.
  final TextTone tone;

  /// Text weight for the choice label.
  final FontWeight weight;
}
