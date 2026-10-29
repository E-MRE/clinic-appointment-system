part of 'auth_page.dart';

/// Feedback message and submit button block for auth forms.
final class _AuthFormActions<C extends AuthRequestCubit>
    extends StatelessWidget {
  const _AuthFormActions({required this.kind, required this.onSubmit});

  final AuthFormKind kind;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AuthFormFeedback<C>(kind: kind),
        _AuthSubmitButton<C>(kind: kind, onSubmit: onSubmit),
      ],
    );
  }
}
