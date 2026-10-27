part of 'auth_page.dart';

/// UI-only password confirmation, checked by the enclosing Form.
final class _AuthConfirmationField extends StatelessWidget {
  const _AuthConfirmationField({
    required this.password,
    required this.controller,
    required this.enabled,
    required this.onSubmit,
  });

  final TextEditingController password;
  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return _AuthPasswordField(
      label: LocaleKeys.auth_passwordConfirmation.translate(),
      fieldKey: const WidgetKey.authConfirmation(),
      controller: controller,
      enabled: enabled,
      autofillHints: const [AutofillHints.newPassword],
      textInputAction: TextInputAction.done,
      onSubmitted: onSubmit,
      validator: _validate,
    );
  }

  String? _validate(String? value) {
    return password.text == value
        ? null
        : LocaleKeys.validation_passwordMismatch.translate();
  }
}
