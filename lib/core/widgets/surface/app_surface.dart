import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_padding.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_radius.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_variant.dart';
import 'package:flutter/material.dart';

/// A themed, bordered container for shared cards and panels.
final class AppSurface extends StatelessWidget {
  const AppSurface({
    required this.child,
    this.variant = AppSurfaceVariant.standard,
    this.radius = AppSurfaceRadius.card,
    this.padding = AppSurfacePadding.compact,
    this.clipBehavior = Clip.none,
    super.key,
  });

  final Widget child;
  final AppSurfaceVariant variant;
  final AppSurfaceRadius radius;
  final AppSurfacePadding padding;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Container(
      padding: padding.value,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: variant.background(colors),
        borderRadius: radius.value,
        border: Border.all(
          color: variant.border(colors),
          width: variant.borderWidth,
        ),
      ),
      child: child,
    );
  }
}
