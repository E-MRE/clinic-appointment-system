part of 'auth_page.dart';

/// Connects request/session listeners to the screen's form and layout.
final class _AuthRequestForm<C extends AuthRequestCubit>
    extends StatefulWidget {
  const _AuthRequestForm({required this.page});

  final AuthPage<C> page;

  @override
  State<_AuthRequestForm<C>> createState() {
    return _AuthRequestFormState<C>();
  }
}

final class _AuthRequestFormState<C extends AuthRequestCubit>
    extends State<_AuthRequestForm<C>>
    with _AuthRequestFormMixin<C> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(listener: _onSessionChanged),
        BlocListener<C, AuthRequestState>(listener: _onRequestChanged),
      ],
      child: BlocBuilder<C, AuthRequestState>(
        buildWhen: _busyStateChanged,
        builder: (context, state) {
          return _AuthPageLayout(
            kind: _kind,
            canNavigate: !_kind.isBusy(state),
            child: Form(
              key: _formKey,
              child: AutofillGroup(
                child: _AuthFormContent<C>(
                  kind: _kind,
                  fullName: _fullName,
                  email: _email,
                  password: _password,
                  confirmation: _confirmation,
                  enabled: !_kind.isBusy(state),
                  onSubmit: _submit,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
