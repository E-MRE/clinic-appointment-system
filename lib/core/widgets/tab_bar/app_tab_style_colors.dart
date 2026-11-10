import 'package:clinic_appointment_system/core/widgets/tab_bar/app_tab_style.dart';
import 'package:flutter/material.dart';

/// Theme colors of an [AppTabStyle].
extension AppTabStyleColors on AppTabStyle {
  /// Underline color, or null when the tab shows no underline.
  Color? indicator(ColorScheme scheme) {
    return switch (this) {
      AppTabStyle.selected => scheme.primary,
      AppTabStyle.unselected => null,
    };
  }
}
