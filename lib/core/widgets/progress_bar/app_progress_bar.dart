import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:flutter/material.dart';

/// A compact horizontal progress bar using the active theme's primary color.
final class AppProgressBar extends StatelessWidget {
  /// Creates a determinate progress bar for a value from zero to one.
  const AppProgressBar({
    required this.value,
    this.semanticsLabel,
    this.height = AppSizes.s8,
    super.key,
  });

  /// Progress between zero and one; values outside the range are clamped.
  final double value;

  /// Optional accessible description of the measured value.
  final String? semanticsLabel;

  /// Height of the track and progress segment.
  final double height;

  /// value = 0
  double get _minimumValue => 0;

  /// value = 1
  double get _maximumValue => 1;

  @override
  Widget build(BuildContext context) {
    final normalizedValue = value
        .clamp(_minimumValue, _maximumValue)
        .toDouble();
    return ClipRRect(
      borderRadius: const AppRadius.full(),
      child: LinearProgressIndicator(
        value: normalizedValue,
        minHeight: height,
        color: context.colorScheme.primary,
        backgroundColor: context.colorScheme.surfaceContainerHighest,
        semanticsLabel: semanticsLabel,
      ),
    );
  }
}
