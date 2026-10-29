part of 'auth_page.dart';

/// Forgot password button for the sign in form.
final class _AuthForgotPasswordButton extends StatelessWidget {
  const _AuthForgotPasswordButton({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
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
