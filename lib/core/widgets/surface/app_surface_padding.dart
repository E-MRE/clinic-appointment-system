import 'package:clinic_appointment_system/core/theme/theme.dart';

/// Preset inner spacing for a surface.
enum AppSurfacePadding {
  /// Padding = 0.
  none(AppPadding.none()),

  /// Padding = 16.
  compact(AppPadding.allLg()),

  /// Padding = 20.
  comfortable(AppPadding.all20()),

  /// Padding = 24.
  spacious(AppPadding.allXl());

  const AppSurfacePadding(this.value);

  /// Inner padding preset for this surface variant.
  final AppPadding value;
}
