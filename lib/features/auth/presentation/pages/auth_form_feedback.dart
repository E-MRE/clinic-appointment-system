part of 'auth_page.dart';

/// Builds request feedback directly from the screen-owned Cubit.
final class _AuthFormFeedback<C extends AuthRequestCubit>
    extends StatelessWidget {
  const _AuthFormFeedback({required this.kind});

  final AuthFormKind kind;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, AuthRequestState>(
      builder: (context, state) {
        if (state is AuthRequestFailure) {
          final message =
              state.errorCode?.messageKey.translate() ?? state.message ?? '';

          return _AuthFeedbackMessage(
            message: message,
            color: context.colorScheme.error,
          );
        }
        final successKey = kind.successMessageKey;
        if (state is AuthRequestSuccess && successKey != null) {
          return _AuthFeedbackMessage(
            message: successKey.translate(),
            color: context.colorScheme.onSurface,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
