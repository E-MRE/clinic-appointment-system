import 'package:clinic_appointment_system/core/theme/app_sizes.dart';
import 'package:flutter/widgets.dart';

/// A [SizedBox] gap whose size comes from the [AppSizes] scale.
///
/// Use these between children of a [Column] or [Row] instead of writing
/// `SizedBox(height: AppSizes.lg)` on each page.
///
/// * xsHeight / xsWidth → 4
/// * smHeight / smWidth → 8
/// * mdHeight / mdWidth → 12
/// * lgHeight / lgWidth → 16
/// * xlHeight / xlWidth → 24
/// * xxlHeight / xxlWidth → 32
/// * xxxlHeight / xxxlWidth → 48
final class EmptySize extends SizedBox {
  // Vertical (height)
  const EmptySize.xsHeight({super.key}) : super(height: AppSizes.xs);
  const EmptySize.smHeight({super.key}) : super(height: AppSizes.sm);
  const EmptySize.mdHeight({super.key}) : super(height: AppSizes.md);
  const EmptySize.lgHeight({super.key}) : super(height: AppSizes.lg);
  const EmptySize.xlHeight({super.key}) : super(height: AppSizes.xl);
  const EmptySize.xxlHeight({super.key}) : super(height: AppSizes.xxl);
  const EmptySize.xxxlHeight({super.key}) : super(height: AppSizes.xxxl);

  // Horizontal (width)
  const EmptySize.xsWidth({super.key}) : super(width: AppSizes.xs);
  const EmptySize.smWidth({super.key}) : super(width: AppSizes.sm);
  const EmptySize.mdWidth({super.key}) : super(width: AppSizes.md);
  const EmptySize.lgWidth({super.key}) : super(width: AppSizes.lg);
  const EmptySize.xlWidth({super.key}) : super(width: AppSizes.xl);
  const EmptySize.xxlWidth({super.key}) : super(width: AppSizes.xxl);
  const EmptySize.xxxlWidth({super.key}) : super(width: AppSizes.xxxl);
}
