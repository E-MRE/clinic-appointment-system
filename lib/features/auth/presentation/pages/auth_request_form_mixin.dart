part of 'auth_page.dart';

/// Owns form controllers and navigation effects separately from widget layout.
mixin _AuthRequestFormMixin<C extends AuthRequestCubit>
    on State<_AuthRequestForm<C>> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();

  AuthFormKind get _kind => widget.page.kind;

  C get _cubit => context.read<C>();

  bool get _isBusy => _kind.isBusy(_cubit.state);

  bool _busyStateChanged(AuthRequestState previous, AuthRequestState current) {
    return _kind.isBusy(previous) != _kind.isBusy(current);
  }

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  void _submit() {
    if (_isBusy || !_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    widget.page.submit(
      _cubit,
      AuthFormValues(
        fullName: _fullName.text,
        email: _email.text,
        password: _password.text,
      ),
    );
  }

  void _onSessionChanged(BuildContext context, AuthState state) {
    _finishIfReady();
  }

  void _onRequestChanged(BuildContext context, AuthRequestState state) {
    _finishIfReady();
  }

  void _finishIfReady() {
    if (!_kind.opensHomeOnSuccess ||
        _cubit.state is! AuthRequestSuccess ||
        !_hasSettledSession) {
      return;
    }
    TextInput.finishAutofillContext();
    Router.neglect(context, _openHome);
  }

  /// Whether the session finished loading its profile, successfully or not;
  /// home shows the profile failure with retry and sign-out.
  bool get _hasSettledSession {
    final state = context.read<AuthCubit>().state;
    if (state is AuthSignedIn || state is AuthProfileFailure) {
      return true;
    }

    return false;
  }

  /// Runs inside [Router.neglect], so the browser replaces the auth history
  /// entry with home instead of keeping the form one back step away.
  void _openHome() {
    context.go(AppRoutes.home);
  }
}
