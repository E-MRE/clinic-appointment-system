import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:flutter/material.dart';

/// Vertical spacing variants for a shared list row.
enum AppListTileDensity {
  /// Compact row padding.
  dense(AppPadding.listTileDense()),

  /// Standard row padding.
  regular(AppPadding.allLg());

  const AppListTileDensity(this.padding);

  /// Full padding around the row contents.
  final EdgeInsets padding;
}
