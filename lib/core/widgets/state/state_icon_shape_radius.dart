import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/state/state_icon_shape.dart';
import 'package:flutter/material.dart';

/// Corner radius of a [StateIconShape].
extension StateIconShapeRadius on StateIconShape {
  /// Border radius matching this state icon shape.
  BorderRadius get radius {
    return switch (this) {
      StateIconShape.roundedSquare => const AppRadius.xxLarge(),
      StateIconShape.circle => const AppRadius.full(),
    };
  }
}
