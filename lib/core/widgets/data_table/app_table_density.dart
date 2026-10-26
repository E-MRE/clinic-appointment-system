import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_radius.dart';

/// Spacing and corner radius for a table viewport.
enum AppTableDensity {
  /// Desktop spacing and panel corners.
  regular(
    outerPadding: AppSizes.s20,
    middlePadding: AppSizes.s12,
    radius: AppSurfaceRadius.panel,
  ),

  /// Tablet spacing and card corners.
  compact(
    outerPadding: AppSizes.s16,
    middlePadding: AppSizes.s8,
    radius: AppSurfaceRadius.card,
  );

  const AppTableDensity({
    required this.outerPadding,
    required this.middlePadding,
    required this.radius,
  });

  /// Horizontal padding on the outside edges.
  final double outerPadding;

  /// Horizontal padding between columns.
  final double middlePadding;

  /// Surface corner radius.
  final AppSurfaceRadius radius;
}
