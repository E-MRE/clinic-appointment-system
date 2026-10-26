import 'package:clinic_appointment_system/core/theme/app_sizes.dart';
import 'package:flutter/widgets.dart';

/// A [SizedBox] gap whose size comes from the [AppSizes] scale.
///
/// Use these between children of a [Column] or [Row] instead of writing
/// `SizedBox(height: AppSizes.s16)` on each page.
///
/// * s4Height / s4Width → 4
/// * s8Height / s8Width → 8
/// * s12Height / s12Width → 12
/// * s16Height / s16Width → 16
/// * s20Height / s20Width → 20
/// * s24Height / s24Width → 24
/// * s32Height / s32Width → 32
/// * s40Height / s40Width → 40
/// * s48Height / s48Width → 48
/// * s56Height / s56Width → 56
/// * s64Height / s64Width → 64
/// * s72Height / s72Width → 72
/// * s80Height / s80Width → 80
/// * s96Height / s96Width → 96
final class EmptySize extends SizedBox {
  // Vertical (height) — Scale

  /// value = height 4
  const EmptySize.s4Height({super.key}) : super(height: AppSizes.s4);

  /// value = height 8
  const EmptySize.s8Height({super.key}) : super(height: AppSizes.s8);

  /// value = height 12
  const EmptySize.s12Height({super.key}) : super(height: AppSizes.s12);

  /// value = height 16
  const EmptySize.s16Height({super.key}) : super(height: AppSizes.s16);

  /// value = height 20
  const EmptySize.s20Height({super.key}) : super(height: AppSizes.s20);

  /// value = height 24
  const EmptySize.s24Height({super.key}) : super(height: AppSizes.s24);

  /// value = height 32
  const EmptySize.s32Height({super.key}) : super(height: AppSizes.s32);

  /// value = height 40
  const EmptySize.s40Height({super.key}) : super(height: AppSizes.s40);

  /// value = height 48
  const EmptySize.s48Height({super.key}) : super(height: AppSizes.s48);

  /// value = height 56
  const EmptySize.s56Height({super.key}) : super(height: AppSizes.s56);

  /// value = height 64
  const EmptySize.s64Height({super.key}) : super(height: AppSizes.s64);

  /// value = height 72
  const EmptySize.s72Height({super.key}) : super(height: AppSizes.s72);

  /// value = height 80
  const EmptySize.s80Height({super.key}) : super(height: AppSizes.s80);

  /// value = height 96
  const EmptySize.s96Height({super.key}) : super(height: AppSizes.s96);

  // Horizontal (width) — Scale

  /// value = width 4
  const EmptySize.s4Width({super.key}) : super(width: AppSizes.s4);

  /// value = width 8
  const EmptySize.s8Width({super.key}) : super(width: AppSizes.s8);

  /// value = width 12
  const EmptySize.s12Width({super.key}) : super(width: AppSizes.s12);

  /// value = width 16
  const EmptySize.s16Width({super.key}) : super(width: AppSizes.s16);

  /// value = width 20
  const EmptySize.s20Width({super.key}) : super(width: AppSizes.s20);

  /// value = width 24
  const EmptySize.s24Width({super.key}) : super(width: AppSizes.s24);

  /// value = width 32
  const EmptySize.s32Width({super.key}) : super(width: AppSizes.s32);

  /// value = width 40
  const EmptySize.s40Width({super.key}) : super(width: AppSizes.s40);

  /// value = width 48
  const EmptySize.s48Width({super.key}) : super(width: AppSizes.s48);

  /// value = width 56
  const EmptySize.s56Width({super.key}) : super(width: AppSizes.s56);

  /// value = width 64
  const EmptySize.s64Width({super.key}) : super(width: AppSizes.s64);

  /// value = width 72
  const EmptySize.s72Width({super.key}) : super(width: AppSizes.s72);

  /// value = width 80
  const EmptySize.s80Width({super.key}) : super(width: AppSizes.s80);

  /// value = width 96
  const EmptySize.s96Width({super.key}) : super(width: AppSizes.s96);
}
