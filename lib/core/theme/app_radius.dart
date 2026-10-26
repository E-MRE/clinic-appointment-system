import 'package:clinic_appointment_system/core/theme/app_sizes.dart';
import 'package:flutter/painting.dart';

/// A circular [BorderRadius] preset whose values come from the [AppSizes]
/// scale. Use these instead of inline `BorderRadius` values.
///
/// * small → 8
/// * xSmall → 4
/// * medium → 12
/// * large → 16
/// * xLarge → 24
/// * xxLarge → 32
/// * full → 999
final class AppRadius extends BorderRadius {
  /// value = 4
  const AppRadius.xSmall() : super.all(const Radius.circular(AppSizes.s4));

  /// value = 8
  const AppRadius.small() : super.all(const Radius.circular(AppSizes.s8));

  /// value = 12
  const AppRadius.medium() : super.all(const Radius.circular(AppSizes.s12));

  /// value = 16
  const AppRadius.large() : super.all(const Radius.circular(AppSizes.s16));

  /// value = 24
  const AppRadius.xLarge() : super.all(const Radius.circular(AppSizes.s24));

  /// value = 32
  const AppRadius.xxLarge() : super.all(const Radius.circular(AppSizes.s32));

  /// Pill shape. Large enough to fully round any control.
  ///
  /// value = 999
  const AppRadius.full() : super.all(const Radius.circular(999));
}
