import 'package:clinic_appointment_system/core/widgets/dashed_border/app_dashed_border_painter.dart';
import 'package:flutter/material.dart';

/// Paints a dashed rounded outline over an arbitrary child.
final class AppDashedBorder extends StatelessWidget {
  /// Creates an outline using the caller's themed color and shape.
  const AppDashedBorder({
    required this.child,
    required this.color,
    required this.strokeWidth,
    required this.radius,
    super.key,
  });

  /// Content enclosed by the outline.
  final Widget child;

  /// Theme color of the dashes.
  final Color color;

  /// Thickness of each dash.
  final double strokeWidth;

  /// Rounded outline shape.
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: AppDashedBorderPainter(
        color: color,
        strokeWidth: strokeWidth,
        radius: radius,
      ),
      child: child,
    );
  }
}
