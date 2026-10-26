import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

part 'app_filter_chips.dart';
part 'app_segmented_control.dart';
part 'filter_chip_item.dart';
part 'segment_item.dart';
part 'choice_item.dart';

/// A label and typed value used by single selection controls.
final class AppChoice<T> {
  /// Creates a visible choice with its associated value.
  const AppChoice({required this.value, required this.label});

  /// Selected value represented by this choice.
  final T value;

  /// Visible choice label.
  final String label;
}

/// Shared visual decisions for filter chips and segments.
enum _ChoiceStyle {
  chip(AppRadius.small(), 1, TextOverflow.ellipsis),
  segment(AppRadius.full(), 1, TextOverflow.ellipsis);

  const _ChoiceStyle(this.radius, this.maxLines, this.overflow);

  final BorderRadius radius;
  final int maxLines;
  final TextOverflow overflow;

  Color background(ColorScheme scheme, bool selected) {
    return selected ? scheme.secondaryContainer : scheme.surface;
  }

  TextTone tone(bool selected) {
    return selected ? TextTone.onSecondaryContainer : TextTone.normal;
  }

  FontWeight weight(bool selected) {
    return selected ? FontWeight.w600 : FontWeight.w500;
  }
}
