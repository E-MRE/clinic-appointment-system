part of 'admin_home_page.dart';

/// Clears demo data after the administrator confirms the request.
final class _AdminHomeHeaderClearDemoDataButton extends StatelessWidget {
  /// Creates the demo data clearing action.
  const _AdminHomeHeaderClearDemoDataButton({
    required this.state,
    required this.onConfirm,
  });

  final DemoDataState state;
  final Future<void> Function(BuildContext) onConfirm;

  @override
  Widget build(BuildContext context) {
    final state = this.state;
    final isRequestInProgress = state is DemoDataLoading;
    final isLoading =
        state is DemoDataLoading && state.command == DemoDataCommand.clear;
    final colors = context.colorScheme;
    VoidCallback? onPressed;
    if (!isRequestInProgress) {
      onPressed = () {
        onConfirm(context);
      };
    }
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: colors.errorContainer,
        foregroundColor: colors.onErrorContainer,
      ),
      icon: _AdminHomeHeaderDemoDataButtonIcon(
        isLoading: isLoading,
        icon: Icons.delete_sweep_outlined,
        color: colors.onErrorContainer,
      ),
      label: AppText.label(
        LocaleKeys.demoData_clearButton.translate(),
        tone: TextTone.onErrorContainer,
      ),
    );
  }
}
