import 'dart:math' as math;

import 'package:clinic_appointment_system/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';

/// Draws equally spaced dashes along an inset rounded rectangle.
final class AppDashedBorderPainter extends CustomPainter {
  /// Creates the immutable outline painter.
  const AppDashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
  });

  /// Outline color.
  final Color color;

  /// Outline thickness.
  final double strokeWidth;

  /// Outline corner radii.
  final BorderRadius radius;

  /// Initial distance along the outline.
  double get _startOffset => 0;

  /// Divisor for centering the stroke inside its bounds.
  double get _halfStrokeDivisor => 2;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(strokeWidth / _halfStrokeDivisor);
    if (rect.isEmpty) return;
    final path = Path()..addRRect(radius.toRRect(rect));
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    for (final metric in path.computeMetrics()) {
      for (
        double offset = _startOffset;
        offset < metric.length;
        offset += AppSizes.dashedBorderDash + AppSizes.dashedBorderGap
      ) {
        canvas.drawPath(
          metric.extractPath(
            offset,
            math.min(offset + AppSizes.dashedBorderDash, metric.length),
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(AppDashedBorderPainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      radius != oldDelegate.radius;
}
