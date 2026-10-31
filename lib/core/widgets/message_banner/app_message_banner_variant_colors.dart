import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/message_banner/app_message_banner_style.dart';
import 'package:clinic_appointment_system/core/widgets/message_banner/app_message_banner_variant.dart';
import 'package:flutter/material.dart';

/// Resolves banner colors, tones, sizes and default icons per variant.
extension AppMessageBannerVariantColors on AppMessageBannerVariant {
  Color background(ColorScheme scheme) => switch (this) {
    AppMessageBannerVariant.info => scheme.secondaryContainer,
    AppMessageBannerVariant.highlight => scheme.primaryContainer,
    AppMessageBannerVariant.error => scheme.errorContainer,
  };
  Color foreground(ColorScheme scheme) => switch (this) {
    AppMessageBannerVariant.info => scheme.onSecondaryContainer,
    AppMessageBannerVariant.highlight => scheme.onPrimaryContainer,
    AppMessageBannerVariant.error => scheme.onErrorContainer,
  };
  TextTone get tone => switch (this) {
    AppMessageBannerVariant.info => TextTone.onSecondaryContainer,
    AppMessageBannerVariant.highlight => TextTone.onPrimaryContainer,
    AppMessageBannerVariant.error => TextTone.onErrorContainer,
  };

  /// Size and text configuration of this variant.
  AppMessageBannerStyle get style => switch (this) {
    AppMessageBannerVariant.info => const AppMessageBannerStyle.compact(),
    AppMessageBannerVariant.highlight => const AppMessageBannerStyle.regular(),
    AppMessageBannerVariant.error => const AppMessageBannerStyle.regular(),
  };

  /// Icon shown when the caller supplies none.
  IconData? get defaultIcon => switch (this) {
    AppMessageBannerVariant.info => null,
    AppMessageBannerVariant.highlight => null,
    AppMessageBannerVariant.error => Icons.error_outline,
  };

  /// Whether screen readers announce the message when it appears.
  bool get isAnnounced => this == AppMessageBannerVariant.error;
}
