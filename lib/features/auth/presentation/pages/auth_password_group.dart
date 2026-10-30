part of 'auth_page.dart';

/// Password fields group with top spacing for auth forms.
final class _AuthPasswordGroup extends StatelessWidget {
  const _AuthPasswordGroup({
    required this.kind,
    required this.password,
    required this.confirmation,
    required this.enabled,
    required this.onSubmit,
  });

  final AuthFormKind kind;
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
        const EmptySize.s16Height(),
        _AuthPasswordFields(
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
