part of 'auth_page.dart';

/// Places registration passwords side by side when the viewport allows it.
final class _AuthPasswordFields extends StatelessWidget {
  const _AuthPasswordFields({
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
    if (kind.isRegistration && !context.screenSize.isMobile) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _password),
          const EmptySize.s16Width(),
          Expanded(child: _confirmation),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _password,
        if (kind.isRegistration) ...[
          const EmptySize.s16Height(),
          _confirmation,
        ],
      ],
    );
  }

  Widget get _password {
    return _AuthPasswordInput(
      kind: kind,
      controller: password,
      enabled: enabled,
      onSubmit: onSubmit,
    );
  }

  Widget get _confirmation {
    return _AuthConfirmationField(
      password: password,
      controller: confirmation,
      enabled: enabled,
      onSubmit: onSubmit,
    );
  }
}
