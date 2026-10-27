part of 'auth_page.dart';

/// Email input reused by sign-in, registration and password reset.
final class _AuthEmailField extends StatelessWidget
    with AuthInputValidationMixin {
  const _AuthEmailField({
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
    return AppTextField(
      label: LocaleKeys.auth_email.translate(),
      hint: LocaleKeys.auth_emailHint.translate(),
      fieldKey: const WidgetKey.authEmail(),
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      textInputAction: kind.hasPassword
          ? TextInputAction.next
          : TextInputAction.done,
      onSubmitted: kind.isPasswordReset ? onSubmit : null,
      prefixIconAsset: kind.isSignIn ? Assets.images.auth.email : null,
      validator: _validate,
    );
  }

  String? _validate(String? value) {
    return emailError(value ?? '')?.message;
  }
}
