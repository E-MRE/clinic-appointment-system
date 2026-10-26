import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/generated/assets.gen.dart';
import 'package:flutter/material.dart';

/// Presentation variant of a session-startup failure.
enum StartupErrorKind {
  offline(
    titleKey: LocaleKeys.startup_offlineTitle,
    descriptionKey: LocaleKeys.startup_offlineDescription,
    offersGoHome: false,
  ),
  failure(
    titleKey: LocaleKeys.startup_errorTitle,
    descriptionKey: LocaleKeys.startup_errorDescription,
    offersGoHome: true,
  );

  const StartupErrorKind({
    required this.titleKey,
    required this.descriptionKey,
    required this.offersGoHome,
  });

  /// Resolves the variant shown for [code].
  factory StartupErrorKind.from(AuthErrorCode code) =>
      code == AuthErrorCode.networkRequestFailed ? offline : failure;

  final String titleKey;
  final String descriptionKey;

  /// Going home needs a connection, so it is hidden while offline.
  final bool offersGoHome;

  SvgGenImage get illustration => switch (this) {
    offline => Assets.images.status.offline,
    failure => Assets.images.status.error,
  };

  /// Background of the illustration badge.
  Color containerColor(ColorScheme colors) => switch (this) {
    offline => colors.secondaryContainer,
    failure => colors.errorContainer,
  };

  /// Glyph color drawn on [containerColor].
  Color onContainerColor(ColorScheme colors) => switch (this) {
    offline => colors.onSecondaryContainer,
    failure => colors.onErrorContainer,
  };
}
