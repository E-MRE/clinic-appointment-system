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
        if (kind.isRegistration && !context.screenSize.isMobile)
          _buildRegistrationFields()
        else
          _buildStackedFields(),
      ],
    );
  }

  /// Places registration password fields side by side on wider screens.
  Widget _buildRegistrationFields() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildPasswordInput()),
        const EmptySize.s16Width(),
        Expanded(child: _buildConfirmationField()),
      ],
    );
  }

  /// Stacks password fields on mobile and for non-registration forms.
  Widget _buildStackedFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPasswordInput(),
        if (kind.isRegistration) ...[
          const EmptySize.s16Height(),
          _buildConfirmationField(),
        ],
      ],
    );
  }

  /// Builds the password input with its existing form rules.
  Widget _buildPasswordInput() {
    return _AuthPasswordInput(
      kind: kind,
      controller: password,
      enabled: enabled,
      onSubmit: onSubmit,
    );
  }

  /// Builds the confirmation input for registration forms.
  Widget _buildConfirmationField() {
    return _AuthConfirmationField(
      password: password,
      controller: confirmation,
      enabled: enabled,
      onSubmit: onSubmit,
    );
  }
}
