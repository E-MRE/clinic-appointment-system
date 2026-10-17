import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// String extensions for convenient localization.
extension LocalizationExtension on String {
  /// Translates this key using [EasyLocalization].
  String translate({
    List<String>? args,
    Map<String, String>? namedArgs,
    String? gender,
    BuildContext? context,
  }) {
    return tr(
      this,
      args: args,
      namedArgs: namedArgs,
      gender: gender,
      context: context,
    );
  }

  /// Checks if translation exists for this key.
  bool isTranslateExists({BuildContext? context}) {
    return trExists(this, context: context);
  }
}

/// BuildContext extensions for localization delegates and locale helpers.
extension LocalizationContextExtension on BuildContext {
  /// Returns the supported locale list configured on [EasyLocalization].
  List<Locale> get supportedLocaleList => supportedLocales;

  /// Returns the localization delegate list from [EasyLocalization].
  List<LocalizationsDelegate<dynamic>> get localizationDelegateList =>
      localizationDelegates;

  /// Returns the current active locale.
  Locale get currentLocale => locale;

  /// Switches the active locale at runtime without restarting the app.
  Future<void> switchLocale(Locale newLocale) => setLocale(newLocale);
}
