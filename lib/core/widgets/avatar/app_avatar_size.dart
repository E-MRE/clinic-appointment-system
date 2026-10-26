import 'package:clinic_appointment_system/core/theme/theme.dart';

/// Initials avatar sizes used in shared list rows.
enum AppAvatarSize {
  /// 32 px compact avatar.
  small(AppSizes.s32, TextRole.badge),

  /// 40 px regular avatar.
  medium(AppSizes.s40, TextRole.label),

  /// 48 px prominent avatar.
  large(AppSizes.s48, TextRole.cardTitle);

  const AppAvatarSize(this.diameter, this.initialsRole);

  /// Avatar diameter in logical pixels.
  final double diameter;

  /// Text role supplying the scaled initials size.
  final TextRole initialsRole;
}
