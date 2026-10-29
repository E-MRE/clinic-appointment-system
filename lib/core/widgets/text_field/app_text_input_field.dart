part of 'app_text_field.dart';

/// Semantic wrapper and underlying text form field for app text inputs.
final class _AppTextInputField extends StatelessWidget {
  const _AppTextInputField({
    required this.label,
    required this.fieldKey,
    required this.controller,
    required this.enabled,
    required this.validator,
    required this.keyboardType,
    required this.autofillHints,
    required this.textInputAction,
    required this.onSubmitted,
    required this.obscureText,
    required this.autocorrect,
    required this.enableSuggestions,
    required this.decoration,
  });

  final String label;
  final Key? fieldKey;
  final TextEditingController? controller;
  final bool enabled;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final VoidCallback? onSubmitted;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  final InputDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return Semantics(
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
        decoration: decoration,
      ),
    );
  }
}
