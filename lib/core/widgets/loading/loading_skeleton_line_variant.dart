import 'package:clinic_appointment_system/core/theme/theme.dart';

/// Width and height decisions for loading placeholders.
enum LoadingSkeletonLineVariant {
  /// First heading placeholder.
  headingWide(0.55, AppSizes.s16),

  /// Second heading placeholder.
  headingShort(0.35, AppSizes.s16),

  /// Card title placeholder.
  title(0.7, AppSizes.s16),

  /// Metadata placeholder.
  metadata(0.45, AppSizes.s12),

  /// Long description placeholder.
  body(0.8, AppSizes.s12),

  /// Full width row placeholder.
  fullWidth(1, AppSizes.s12);

  const LoadingSkeletonLineVariant(this.widthFactor, this.height);

  /// Relative width of the placeholder line.
  final double widthFactor;

  /// Height of the placeholder line.
  final double height;
}
