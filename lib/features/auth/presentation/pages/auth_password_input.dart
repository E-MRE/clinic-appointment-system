part of 'auth_page.dart';

/// Password input with the existing-account or new-registration rules.
final class _AuthPasswordInput extends StatelessWidget
    with AuthInputValidationMixin {
  const _AuthPasswordInput({
    required this.kind,
    required this.controller,
    required this.enabled,
    required this.onSubmit,
  });

  final AuthFormKind kind;
  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return _AuthPasswordField(
      label: LocaleKeys.auth_password.translate(),
      fieldKey: const WidgetKey.authPassword(),
      controller: controller,
      enabled: enabled,
      showPrefix: kind.isSignIn,
      autofillHints: [
        kind.isRegistration
            ? AutofillHints.newPassword
            : AutofillHints.password,
      ],
      helper: _helper,
      textInputAction: kind.isRegistration
          ? TextInputAction.next
          : TextInputAction.done,
      onSubmitted: kind.isRegistration ? null : onSubmit,
      validator: _validate,
    );
  }

  String? get _helper {
    if (!kind.isRegistration) {
      return null;
    }
    return LocaleKeys.auth_passwordHint.translate(
      namedArgs: TranslationArgs.forMinimumLength(
        ValidationConstants.minimumPasswordLength,
      ),
    );
  }

  String? _validate(String? value) {
    return passwordError(value ?? '', isSignUp: kind.isRegistration)?.message;
  }
}
