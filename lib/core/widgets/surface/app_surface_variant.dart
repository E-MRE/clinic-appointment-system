import 'package:clinic_appointment_system/core/theme/theme.dart';

/// Shape and emphasis options for [AppSurface].
enum AppSurfaceVariant {
  /// Standard surface using the low surface container.
  standard(borderWidth: AppSizes.borderThin),

  /// Highlighted surface using the primary container.
  highlighted(borderWidth: AppSizes.borderThick);

  const AppSurfaceVariant({required this.borderWidth});

  /// Width of the surface border.
  final double borderWidth;
}
