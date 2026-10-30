import 'package:clinic_appointment_system/features/auth/presentation/enums/startup_error_kind.dart';
import 'package:clinic_appointment_system/features/auth/presentation/models/startup_error_config.dart';
import 'package:clinic_appointment_system/generated/assets.gen.dart';
import 'package:flutter/material.dart';

/// Content, illustration and colors of a [StartupErrorKind] screen.
extension StartupErrorKindPresentation on StartupErrorKind {
  /// Copy and available actions for this failure.
  StartupErrorConfig get config {
    return switch (this) {
      StartupErrorKind.offline => const StartupErrorConfig.offline(),
      StartupErrorKind.failure => const StartupErrorConfig.failure(),
      StartupErrorKind.profileMissing =>
        const StartupErrorConfig.profileMissing(),
      StartupErrorKind.invalidProfile =>
        const StartupErrorConfig.invalidProfile(),
      StartupErrorKind.profileUnavailable =>
        const StartupErrorConfig.profileUnavailable(),
    };
  }

  /// Whether the failure comes from a missing connection.
  bool get _isConnectionFailure {
    return this == StartupErrorKind.offline ||
        this == StartupErrorKind.profileUnavailable;
  }

  /// Illustration shown above the title.
  SvgGenImage get illustration {
    if (_isConnectionFailure) return Assets.images.status.offline;
    return Assets.images.status.error;
  }

  /// Background of the illustration badge.
  Color containerColor(ColorScheme colors) {
    if (_isConnectionFailure) return colors.secondaryContainer;
    return colors.errorContainer;
  }

  /// Glyph color drawn on [containerColor].
  Color onContainerColor(ColorScheme colors) {
    if (_isConnectionFailure) return colors.onSecondaryContainer;
    return colors.onErrorContainer;
  }
}
