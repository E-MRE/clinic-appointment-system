import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/square_svg_icon.dart';
import 'package:clinic_appointment_system/generated/assets.gen.dart';
import 'package:flutter/material.dart';

/// Themed labeled text input shared by feature forms.
final class AppTextField extends StatelessWidget {
  /// Creates a labeled text input from display values and form behavior.
  const AppTextField({
    required this.label,
    required this.controller,
    this.enabled = true,
    this.validator,
    this.fieldKey,
    this.hint,
    this.helper,
    this.keyboardType,
    this.autofillHints,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.prefixIconAsset,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.autocorrect = false,
    this.enableSuggestions = false,
    this.fillColor,
    super.key,
  });

  /// Accessible field label.
  final String label;

  /// Controller owned by the containing feature.
  final TextEditingController controller;

  /// Whether the field accepts input.
  final bool enabled;

  /// Optional form validation behavior.
  final String? Function(String?)? validator;

  /// Optional key for the underlying form field.
  final Key? fieldKey;

  /// Optional input hint.
  final String? hint;

  /// Optional helper text.
  final String? helper;

  /// Optional keyboard type.
  final TextInputType? keyboardType;

  /// Optional operating-system autofill hints.
  final Iterable<String>? autofillHints;

  /// Action shown by the keyboard.
  final TextInputAction textInputAction;

  /// Callback invoked after submitting the field.
  final VoidCallback? onSubmitted;

  /// Optional decorative SVG displayed in the standard prefix slot.
  final SvgGenImage? prefixIconAsset;

  /// Optional leading content inside the input.
  final Widget? prefix;

  /// Optional trailing content inside the input.
  final Widget? suffix;

  /// Whether entered text is obscured.
  final bool obscureText;

  /// Whether the platform may correct the entered text.
  final bool autocorrect;

  /// Whether suggestions are enabled.
  final bool enableSuggestions;

  /// Optional surface fill override.
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    final decorationTheme = context.theme.inputDecorationTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExcludeSemantics(child: AppText.label(label)),
        const EmptySize.s8Height(),
        Semantics(
          label: label,
          child: TextFormField(
            key: fieldKey,
            controller: controller,
            enabled: enabled,
            validator: validator,
            keyboardType: keyboardType,
            autofillHints: autofillHints,
            textInputAction: textInputAction,
            onFieldSubmitted: (_) {
              onSubmitted?.call();
            },
            obscureText: obscureText,
            autocorrect: autocorrect,
            enableSuggestions: enableSuggestions,
            style: context.textTheme.bodyLarge,
            decoration: InputDecoration(
              fillColor:
                  fillColor ??
                  context.screenSize.select(
                    mobile: decorationTheme.fillColor,
                    tablet: context.colorScheme.surface,
                    desktop: decorationTheme.fillColor,
                  ),
              hintText: hint,
              helperText: helper,
              helperMaxLines: null,
              errorMaxLines: null,
              prefixIcon: switch (prefixIconAsset) {
                final iconAsset? => SizedBox.square(
                  dimension: AppSizes.s48,
                  child: SquareSvgIcon(
                    asset: iconAsset,
                    size: AppSizes.retryIcon,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                _ => prefix,
              },
              suffixIcon: suffix,
            ),
          ),
        ),
      ],
    );
  }
}
