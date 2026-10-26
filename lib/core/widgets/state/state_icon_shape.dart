import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:flutter/material.dart';

/// Shape choices for the decorative state icon.
enum StateIconShape {
  /// Rounded square with the approved large radius.
  roundedSquare,

  /// Circular icon background.
  circle;

  /// Border radius matching this state icon shape.
  BorderRadius get radius {
    return switch (this) {
      roundedSquare => const AppRadius.xxLarge(),
      circle => const AppRadius.full(),
    };
  }
}
