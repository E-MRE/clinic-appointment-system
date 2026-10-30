part of 'auth_page.dart';

/// Declares the visible inputs; each field owns its form validation.
final class _AuthFormFields extends StatelessWidget {
  const _AuthFormFields({
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (kind.isRegistration)
          _AuthNameGroup(controller: fullName, enabled: enabled),
        _AuthEmailField(
          kind: kind,
          controller: email,
          enabled: enabled,
          onSubmit: onSubmit,
        ),
        if (kind.hasPassword)
          _AuthPasswordGroup(
            kind: kind,
            password: password,
            confirmation: confirmation,
            enabled: enabled,
            onSubmit: onSubmit,
          ),
      ],
    );
  }
}
