import 'package:clinic_appointment_system/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';

/// An [EdgeInsets] preset whose values come from the [AppSizes] scale.
///
/// * none → all 0
/// * allXs → all 4
/// * allSm → all 8
/// * allMd → all 12
/// * allLg → all 16
/// * allXl → all 24
/// * allXxl → all 32
/// * horizontalSm → horizontal 8
/// * horizontalLg → horizontal 16
/// * horizontalXl → horizontal 24
/// * verticalSm → vertical 8
/// * verticalLg → vertical 16
/// * verticalXl → vertical 24
/// * control → horizontal 16, vertical 12
/// * chip → horizontal 12, vertical 4
/// * pageMobile → all 16
/// * pageTablet → all 24
/// * pageDesktop → all 32
final class AppPadding extends EdgeInsets {
  /// value = all 0
  const AppPadding.none() : super.all(0);

  /// value = all 4
  const AppPadding.allXs() : super.all(AppSizes.xs);

  /// value = all 8
  const AppPadding.allSm() : super.all(AppSizes.sm);

  /// value = all 12
  const AppPadding.allMd() : super.all(AppSizes.md);

  /// value = all 16
  const AppPadding.allLg() : super.all(AppSizes.lg);

  /// value = all 24
  const AppPadding.allXl() : super.all(AppSizes.xl);

  /// value = all 32
  const AppPadding.allXxl() : super.all(AppSizes.xxl);

  /// value = horizontal 8
  const AppPadding.horizontalSm() : super.symmetric(horizontal: AppSizes.sm);

  /// value = horizontal 16
  const AppPadding.horizontalLg() : super.symmetric(horizontal: AppSizes.lg);

  /// value = horizontal 24
  const AppPadding.horizontalXl() : super.symmetric(horizontal: AppSizes.xl);

  /// value = vertical 8
  const AppPadding.verticalSm() : super.symmetric(vertical: AppSizes.sm);

  /// value = vertical 16
  const AppPadding.verticalLg() : super.symmetric(vertical: AppSizes.lg);

  /// value = vertical 24
  const AppPadding.verticalXl() : super.symmetric(vertical: AppSizes.xl);

  /// Button and input content padding.
  ///
  /// value = horizontal 16, vertical 12
  const AppPadding.control()
    : super.symmetric(horizontal: AppSizes.lg, vertical: AppSizes.md);

  /// Chip and badge content padding.
  ///
  /// value = horizontal 12, vertical 4
  const AppPadding.chip()
    : super.symmetric(horizontal: AppSizes.md, vertical: AppSizes.xs);

  /// value = all 16
  const AppPadding.pageMobile() : super.all(AppSizes.lg);

  /// value = all 24
  const AppPadding.pageTablet() : super.all(AppSizes.xl);

  /// value = all 32
  const AppPadding.pageDesktop() : super.all(AppSizes.xxl);
}
