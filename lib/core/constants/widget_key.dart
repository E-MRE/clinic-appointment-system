import 'package:flutter/foundation.dart';

final class WidgetKey extends ValueKey<String> {
  const WidgetKey.themeToggleKey() : super('theme_toggle');
  const WidgetKey.splashPage() : super('splash_page');
  const WidgetKey.startupErrorPage() : super('startup_error_page');
  const WidgetKey.startupRetry() : super('startup_retry');

  /// value = auth_email
  const WidgetKey.authEmail() : super('auth_email');

  /// value = auth_password
  const WidgetKey.authPassword() : super('auth_password');

  /// value = auth_full_name
  const WidgetKey.authFullName() : super('auth_full_name');

  /// value = auth_confirmation
  const WidgetKey.authConfirmation() : super('auth_confirmation');

  /// value = auth_submit
  const WidgetKey.authSubmit() : super('auth_submit');

  /// value = auth_feedback
  const WidgetKey.authFeedback() : super('auth_feedback');
}
