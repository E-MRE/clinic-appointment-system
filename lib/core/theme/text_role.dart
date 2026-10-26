import 'package:flutter/material.dart';

/// Semantic text roles backed by the application's [TextTheme].
enum TextRole {
  /// Splash, authentication hero and KPI value text.
  display,

  /// Authentication, error and success titles.
  headline,

  /// Main page heading.
  pageTitle,

  /// Dialog, sheet and detail section heading.
  sectionTitle,

  /// Card and panel heading.
  cardTitle,

  /// Input text and lead paragraph.
  bodyLarge,

  /// Default paragraph and secondary line.
  body,

  /// Metadata, helper, hint and timestamp text.
  caption,

  /// Button labels and emphasized inline text.
  bodyStrong,

  /// Form labels, chips and options.
  label,

  /// Status pills, table headings and overlines.
  badge;

  /// Resolves this role to its configured text style.
  TextStyle? resolve(TextTheme textTheme) {
    return switch (this) {
      TextRole.display => textTheme.displaySmall,
      TextRole.headline => textTheme.headlineMedium,
      TextRole.pageTitle => textTheme.headlineSmall,
      TextRole.sectionTitle => textTheme.titleLarge,
      TextRole.cardTitle => textTheme.titleMedium,
      TextRole.bodyLarge => textTheme.bodyLarge,
      TextRole.body => textTheme.bodyMedium,
      TextRole.caption => textTheme.bodySmall,
      TextRole.bodyStrong => textTheme.labelLarge,
      TextRole.label => textTheme.labelMedium,
      TextRole.badge => textTheme.labelSmall,
    };
  }
}
