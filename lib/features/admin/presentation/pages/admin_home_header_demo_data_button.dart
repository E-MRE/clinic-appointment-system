part of 'admin_home_page.dart';

/// Starts loading demo data after the administrator confirms the request.
final class _AdminHomeHeaderDemoDataButton extends StatelessWidget {
  /// Creates the demo data loading action.
  const _AdminHomeHeaderDemoDataButton({
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
        state is DemoDataLoading && state.command == DemoDataCommand.load;
    VoidCallback? onPressed;
    if (!isRequestInProgress) {
      onPressed = () {
        onConfirm(context);
      };
    }
    return FilledButton.icon(
      onPressed: onPressed,
      icon: _AdminHomeHeaderDemoDataButtonIcon(
        isLoading: isLoading,
        icon: Icons.cloud_download_outlined,
        color: context.colorScheme.onPrimary,
      ),
      label: AppText.label(
        LocaleKeys.demoData_loadButton.translate(),
        tone: TextTone.onPrimary,
      ),
    );
  }
}
