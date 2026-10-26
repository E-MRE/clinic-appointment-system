import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:flutter/material.dart';

/// Text rendered with one semantic role and tone from the active theme.
final class AppText extends StatelessWidget {
  /// Displays text using a runtime-selected semantic role.
  const AppText(
    this.data, {
    required this.role,
    this.tone = TextTone.normal,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.fontWeight,
    this.semanticsLabel,
    super.key,
  });

  /// Displays splash, authentication hero or KPI value text.
  const AppText.display(
    this.data, {
    this.tone = TextTone.normal,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.fontWeight,
    this.semanticsLabel,
    super.key,
  }) : role = TextRole.display;

  /// Displays an authentication, error or success title.
  const AppText.headline(
    this.data, {
    this.tone = TextTone.normal,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.fontWeight,
    this.semanticsLabel,
    super.key,
  }) : role = TextRole.headline;

  /// Displays a page heading.
  const AppText.pageTitle(
    this.data, {
    this.tone = TextTone.normal,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.fontWeight,
    this.semanticsLabel,
    super.key,
  }) : role = TextRole.pageTitle;

  /// Displays a dialog, sheet or section heading.
  const AppText.sectionTitle(
    this.data, {
    this.tone = TextTone.normal,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.fontWeight,
    this.semanticsLabel,
    super.key,
  }) : role = TextRole.sectionTitle;

  /// Displays a card or panel heading.
  const AppText.cardTitle(
    this.data, {
    this.tone = TextTone.normal,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.fontWeight,
    this.semanticsLabel,
    super.key,
  }) : role = TextRole.cardTitle;

  /// Displays input text or a lead paragraph.
  const AppText.bodyLarge(
    this.data, {
    this.tone = TextTone.normal,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.fontWeight,
    this.semanticsLabel,
    super.key,
  }) : role = TextRole.bodyLarge;

  /// Displays a default paragraph or secondary line.
  const AppText.body(
    this.data, {
    this.tone = TextTone.normal,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.fontWeight,
    this.semanticsLabel,
    super.key,
  }) : role = TextRole.body;

  /// Displays metadata, helper, hint or timestamp text.
  const AppText.caption(
    this.data, {
    this.tone = TextTone.normal,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.fontWeight,
    this.semanticsLabel,
    super.key,
  }) : role = TextRole.caption;

  /// Displays a button label or emphasized inline text.
  const AppText.bodyStrong(
    this.data, {
    this.tone = TextTone.normal,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.fontWeight,
    this.semanticsLabel,
    super.key,
  }) : role = TextRole.bodyStrong;

  /// Displays a form label, chip or option.
  const AppText.label(
    this.data, {
    this.tone = TextTone.normal,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.fontWeight,
    this.semanticsLabel,
    super.key,
  }) : role = TextRole.label;

  /// Displays a status pill, table heading or overline.
  const AppText.badge(
    this.data, {
    this.tone = TextTone.normal,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.fontWeight,
    this.semanticsLabel,
    super.key,
  }) : role = TextRole.badge;

  /// Text content to display.
  final String data;

  /// Semantic typography role.
  final TextRole role;

  /// Semantic foreground color role.
  final TextTone tone;

  /// Alignment of the text within its line.
  final TextAlign? textAlign;

  /// Maximum number of lines to display.
  final int? maxLines;

  /// How visual overflow is handled.
  final TextOverflow? overflow;

  /// Whether the text wraps at soft line breaks.
  final bool? softWrap;

  /// Optional component-level weight override.
  final FontWeight? fontWeight;

  /// Semantic label announced in place of [data].
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final brandColors = context.brandColors;
    final style = role
        .resolve(context.textTheme)
        ?.copyWith(
          color: tone.resolve(
            context.colorScheme,
            brandForeground: brandColors.splashForeground,
          ),
          fontWeight: fontWeight,
        );
    return Text(
      data,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      semanticsLabel: semanticsLabel,
    );
  }
}
