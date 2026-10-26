part of 'auth_page.dart';

/// Patient name input with the shared name validation rule.
final class _AuthNameField extends StatelessWidget with AuthValidationMixin {
  const _AuthNameField({required this.controller, required this.enabled});

  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return _AuthTextField(
      label: LocaleKeys.auth_fullName.translate(),
      hint: LocaleKeys.auth_fullNameHint.translate(),
      fieldKey: const WidgetKey.authFullName(),
      controller: controller,
      enabled: enabled,
      autofillHints: const [AutofillHints.name],
      keyboardType: TextInputType.name,
      validator: _validate,
    );
  }

  String? _validate(String? value) {
    final result = validateFullName(value ?? '');
    return result.isNotSuccess ? result.message : null;
  }
}
