part of 'auth_page.dart';

/// Patient name input with the shared name validation rule.
final class _AuthNameField extends StatelessWidget
    with AuthInputValidationMixin {
  const _AuthNameField({required this.controller, required this.enabled});

  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
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
    return fullNameError(value ?? '')?.message;
  }
}
