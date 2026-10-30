import 'package:clinic_appointment_system/core/localization/localization.dart';

/// Copy and available actions of a startup error screen, one per
/// `StartupErrorKind`.
final class StartupErrorConfig {
  /// The device has no connection; going home needs one, so it is hidden.
  const StartupErrorConfig.offline()
    : titleKey = LocaleKeys.startup_offlineTitle,
      descriptionKey = LocaleKeys.startup_offlineDescription,
      offersGoHome = false,
      offersRetry = true;

  /// The session could not be started for another reason.
  const StartupErrorConfig.failure()
    : titleKey = LocaleKeys.startup_errorTitle,
      descriptionKey = LocaleKeys.startup_errorDescription,
      offersGoHome = true,
      offersRetry = true;

  /// The signed-in account has no profile document.
  const StartupErrorConfig.profileMissing()
    : titleKey = LocaleKeys.startup_profileMissingTitle,
      descriptionKey = LocaleKeys.auth_errors_profileMissing,
      offersGoHome = false,
      offersRetry = false;

  /// The stored profile is incomplete or malformed.
  const StartupErrorConfig.invalidProfile()
    : titleKey = LocaleKeys.startup_invalidProfileTitle,
      descriptionKey = LocaleKeys.auth_errors_invalidProfile,
      offersGoHome = false,
      offersRetry = false;

  /// The profile could not be loaded.
  const StartupErrorConfig.profileUnavailable()
    : titleKey = LocaleKeys.startup_profileUnavailableTitle,
      descriptionKey = LocaleKeys.auth_errors_profileUnavailable,
      offersGoHome = false,
      offersRetry = true;

  /// Translation key of the screen title.
  final String titleKey;

  /// Translation key of the screen description.
  final String descriptionKey;

  /// Whether the screen offers a way back to the home route.
  final bool offersGoHome;

  /// Whether retrying can resolve the failure.
  final bool offersRetry;
}
