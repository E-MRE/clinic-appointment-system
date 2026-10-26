import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
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
  ),

  /// The signed-in account has no profile document; retrying cannot help.
  profileMissing(
    titleKey: LocaleKeys.startup_profileMissingTitle,
    descriptionKey: LocaleKeys.auth_errors_profileMissing,
    offersGoHome: false,
    offersRetry: false,
  ),

  /// The stored profile is incomplete or malformed; retrying cannot help.
  invalidProfile(
    titleKey: LocaleKeys.startup_invalidProfileTitle,
    descriptionKey: LocaleKeys.auth_errors_invalidProfile,
    offersGoHome: false,
    offersRetry: false,
  ),

  /// The profile could not be loaded, usually because of the connection.
  profileUnavailable(
    titleKey: LocaleKeys.startup_profileUnavailableTitle,
    descriptionKey: LocaleKeys.auth_errors_profileUnavailable,
    offersGoHome: false,
  );

  const StartupErrorKind({
    required this.titleKey,
    required this.descriptionKey,
    required this.offersGoHome,
    this.offersRetry = true,
  });

  /// Resolves the variant shown for a session failure [code].
  factory StartupErrorKind.from(AuthErrorCode code) =>
      code == AuthErrorCode.networkRequestFailed ? offline : failure;

  /// Resolves the variant shown for a profile failure [code].
  factory StartupErrorKind.fromProfile(UserErrorCode code) {
    return switch (code) {
      UserErrorCode.profileMissing => profileMissing,
      UserErrorCode.invalidProfile => invalidProfile,
      UserErrorCode.unavailable => profileUnavailable,
    };
  }

  final String titleKey;
  final String descriptionKey;

  /// Going home needs a connection, so it is hidden while offline.
  final bool offersGoHome;

  /// Whether retrying can resolve the failure.
  final bool offersRetry;

  SvgGenImage get illustration => switch (this) {
    offline || profileUnavailable => Assets.images.status.offline,
    failure || profileMissing || invalidProfile => Assets.images.status.error,
  };

  /// Background of the illustration badge.
  Color containerColor(ColorScheme colors) => switch (this) {
    offline || profileUnavailable => colors.secondaryContainer,
    failure || profileMissing || invalidProfile => colors.errorContainer,
  };

  /// Glyph color drawn on [containerColor].
  Color onContainerColor(ColorScheme colors) => switch (this) {
    offline || profileUnavailable => colors.onSecondaryContainer,
    failure || profileMissing || invalidProfile => colors.onErrorContainer,
  };
}
