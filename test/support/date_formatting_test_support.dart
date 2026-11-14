import 'package:intl/date_symbol_data_local.dart';

/// Initializes the locales used by date and time formatting tests.
Future<void> initializeDateFormattingForTests() async {
  for (final locale in const ['tr_TR', 'en_US', 'tr', 'en']) {
    await initializeDateFormatting(locale, null);
  }
}
