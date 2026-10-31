import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:flutter/material.dart';

/// Size and text configuration shared by message banner variants.
///
/// * compact → padding all 12, icon 16, gap 8, caption text
/// * regular → padding horizontal 16 / vertical 12, icon 20, gap 12, body text
final class AppMessageBannerStyle {
  /// Dense banner used for short page notes.
  const AppMessageBannerStyle.compact()
    : padding = const AppPadding.allMd(),
      iconSize = AppSizes.s16,
      iconGap = const EmptySize.s8Width(),
      textRole = TextRole.caption;

  /// Standard banner used inside forms and panels.
  const AppMessageBannerStyle.regular()
    : padding = const AppPadding.control(),
      iconSize = AppSizes.s20,
      iconGap = const EmptySize.s12Width(),
      textRole = TextRole.body;

  /// Inner padding around the icon and message.
  final EdgeInsets padding;

  /// Leading icon size.
  final double iconSize;

  /// Space between the icon and the message.
  final EmptySize iconGap;

  /// Semantic text role of the message.
  final TextRole textRole;
}
