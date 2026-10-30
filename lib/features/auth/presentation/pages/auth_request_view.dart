part of 'auth_page.dart';

/// Builds the auth page layout responding to request busy states.
final class _AuthRequestView<C extends AuthRequestCubit>
    extends StatelessWidget {
  const _AuthRequestView({
    required this.kind,
    required this.formKey,
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmation,
    required this.onSubmit,
    required this.busyStateChanged,
  });

  final AuthFormKind kind;
  final GlobalKey<FormState> formKey;
  final TextEditingController fullName;
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController confirmation;
  final VoidCallback onSubmit;
  final bool Function(AuthRequestState, AuthRequestState) busyStateChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, AuthRequestState>(
      buildWhen: busyStateChanged,
      builder: (context, state) {
        final enabled = !kind.isBusy(state);
        return _AuthPageLayout(
          kind: kind,
          canNavigate: enabled,
          child: _AuthFormHost<C>(
            formKey: formKey,
            kind: kind,
            fullName: fullName,
            email: email,
            password: password,
            confirmation: confirmation,
            enabled: enabled,
            onSubmit: onSubmit,
          ),
        );
      },
    );
  }
}
