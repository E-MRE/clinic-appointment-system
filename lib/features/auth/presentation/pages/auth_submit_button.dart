part of 'auth_page.dart';

/// Builds the submit action and progress indicator from its request Cubit.
final class _AuthSubmitButton<C extends AuthRequestCubit>
    extends StatelessWidget {
  const _AuthSubmitButton({required this.kind, required this.onSubmit});

  final AuthFormKind kind;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, AuthRequestState>(
      builder: (context, state) {
        final isBusy = kind.isBusy(state);
        return FilledButton(
          key: const WidgetKey.authSubmit(),
          onPressed: isBusy ? null : onSubmit,
          child: isBusy ? _progress : Text(kind.config.actionKey.translate()),
        );
      },
    );
  }

  Widget get _progress {
    return AnnouncedSemantics(
      label: LocaleKeys.auth_submitting.translate(),
      child: const SizedBox.square(
        dimension: AppSizes.s24,
        child: CircularProgressIndicator(strokeWidth: AppSizes.s4),
      ),
    );
  }
}
