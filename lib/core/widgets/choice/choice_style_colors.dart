import 'package:clinic_appointment_system/core/widgets/choice/choice_style.dart';
import 'package:flutter/material.dart';

/// Theme colors of a [ChoiceStyle].
extension ChoiceStyleColors on ChoiceStyle {
  /// Background color for this choice state.
  Color background(ColorScheme scheme) {
    return switch (this) {
      ChoiceStyle.selected => scheme.secondaryContainer,
      ChoiceStyle.unselected => scheme.surface,
    };
  }
}
