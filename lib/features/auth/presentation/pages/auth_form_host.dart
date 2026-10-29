part of 'auth_page.dart';

/// Hosts the auth form in a form and autofill group.
final class _AuthFormHost<C extends AuthRequestCubit> extends StatelessWidget {
  const _AuthFormHost({
    required this.formKey,
    required this.kind,
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmation,
    required this.enabled,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final AuthFormKind kind;
  final TextEditingController fullName;
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController confirmation;
  final bool enabled;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: AutofillGroup(
        child: _AuthFormContent<C>(
          kind: kind,
          fullName: fullName,
          email: email,
          password: password,
          confirmation: confirmation,
          enabled: enabled,
          onSubmit: onSubmit,
        ),
      ),
    );
  }
}
