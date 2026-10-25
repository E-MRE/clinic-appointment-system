import 'package:flutter/foundation.dart';

final class WidgetKey extends ValueKey<String> {
  const WidgetKey.themeToggleKey() : super('theme_toggle');
  const WidgetKey.splashPage() : super('splash_page');
  const WidgetKey.startupErrorPage() : super('startup_error_page');
  const WidgetKey.startupRetry() : super('startup_retry');
}
