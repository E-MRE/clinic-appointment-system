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
/// * allXxxl → all 48
/// * authCard → all 40
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
  const AppPadding.allXs() : super.all(AppSizes.s4);

  /// value = all 8
  const AppPadding.allSm() : super.all(AppSizes.s8);

  /// value = all 12
  const AppPadding.allMd() : super.all(AppSizes.s12);

  /// value = all 16
  const AppPadding.allLg() : super.all(AppSizes.s16);

  /// value = all 24
  const AppPadding.allXl() : super.all(AppSizes.s24);

  /// value = all 32
  const AppPadding.allXxl() : super.all(AppSizes.s32);

  /// value = all 48
  const AppPadding.allXxxl() : super.all(AppSizes.s48);

  /// value = all 40
  const AppPadding.authCard() : super.all(AppSizes.authCardPadding);

  /// value = horizontal 8
  const AppPadding.horizontalSm() : super.symmetric(horizontal: AppSizes.s8);

  /// value = horizontal 16
  const AppPadding.horizontalLg() : super.symmetric(horizontal: AppSizes.s16);

  /// value = horizontal 24
  const AppPadding.horizontalXl() : super.symmetric(horizontal: AppSizes.s24);

  /// value = vertical 8
  const AppPadding.verticalSm() : super.symmetric(vertical: AppSizes.s8);

  /// value = vertical 16
  const AppPadding.verticalLg() : super.symmetric(vertical: AppSizes.s16);

  /// value = vertical 24
  const AppPadding.verticalXl() : super.symmetric(vertical: AppSizes.s24);

  /// Button and input content padding.
  ///
  /// value = horizontal 16, vertical 12
  const AppPadding.control()
    : super.symmetric(horizontal: AppSizes.s16, vertical: AppSizes.s12);

  /// Chip and badge content padding.
  ///
  /// value = horizontal 12, vertical 4
  const AppPadding.chip()
    : super.symmetric(horizontal: AppSizes.s12, vertical: AppSizes.s4);

  /// value = all 16
  const AppPadding.pageMobile() : super.all(AppSizes.s16);

  /// value = all 24
  const AppPadding.pageTablet() : super.all(AppSizes.s24);

  /// value = all 32
  const AppPadding.pageDesktop() : super.all(AppSizes.s32);
}
