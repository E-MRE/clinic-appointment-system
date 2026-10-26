part of 'auth_page.dart';

/// Declares the form layout without owning controllers or request effects.
final class _AuthFormContent<C extends AuthRequestCubit>
    extends StatelessWidget {
  const _AuthFormContent({
    required this.kind,
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmation,
    required this.enabled,
    required this.onSubmit,
  });

  final AuthFormKind kind;
  final TextEditingController fullName;
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController confirmation;
  final bool enabled;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AuthFormHeader(kind: kind),
        const EmptySize.s32Height(),
        _AuthFormFields(
          kind: kind,
          fullName: fullName,
          email: email,
          password: password,
          confirmation: confirmation,
          enabled: enabled,
          onSubmit: onSubmit,
        ),
        if (kind.isSignIn) _forgotPassword(context),
        const EmptySize.s24Height(),
        _AuthFormFeedback<C>(kind: kind),
        _AuthSubmitButton<C>(kind: kind, onSubmit: onSubmit),
        const EmptySize.s32Height(),
        if (context.screenSize.isMobile) const Spacer(),
        _AuthFormFooter(kind: kind, enabled: enabled),
      ],
    );
  }

  Widget _forgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: enabled
            ? () {
                context.go(AppRoutes.passwordReset);
              }
            : null,
        child: Text(LocaleKeys.auth_forgotPassword.translate()),
      ),
    );
  }
}
