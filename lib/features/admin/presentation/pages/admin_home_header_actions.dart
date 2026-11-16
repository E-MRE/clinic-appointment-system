part of 'admin_home_page.dart';

/// Provides branch selection and navigation to the appointment list.
final class _AdminHomeHeaderActions extends StatelessWidget {
  const _AdminHomeHeaderActions();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DemoDataCubit, DemoDataState>(
      builder: (context, demoState) {
        final catalogState = context.watch<ClinicCatalogCubit>().state;
        final dashboardState = context.watch<AdminDashboardCubit>().state;
        final selectedBranchId = dashboardState is AdminDashboardLoaded
            ? dashboardState.summary.selectedBranchId
            : null;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSizes.s8,
          children: [
            Wrap(
              spacing: AppSizes.s12,
              runSpacing: AppSizes.s8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _AdminHomeHeaderBranchSelector(
                  catalogState: catalogState,
                  selectedBranchId: selectedBranchId,
                ),
                _appointmentsButton(context),
                _AdminHomeHeaderDemoDataButton(
                  state: demoState,
                  onConfirm: _confirmDemoDataLoad,
                ),
                _AdminHomeHeaderClearDemoDataButton(
                  state: demoState,
                  onConfirm: _confirmDemoDataClear,
                ),
              ],
            ),
            if (demoState is DemoDataLoading)
              _buildDemoFeedback(
                _loadingMessage(demoState.command),
                AppMessageBannerVariant.info,
              ),
            if (demoState is DemoDataSuccess)
              _buildDemoFeedback(
                _successMessage(demoState.command),
                AppMessageBannerVariant.highlight,
              ),
            if (demoState is DemoDataFailure)
              _buildDemoFeedback(
                _failureMessage(demoState),
                AppMessageBannerVariant.error,
              ),
          ],
        );
      },
    );
  }

  Widget _appointmentsButton(BuildContext context) {
    return FilledButton(
      onPressed: () {
        context.go(AppRoutes.adminAppointments);
      },
      child: AppText.label(
        LocaleKeys.admin_appointmentsTitle.translate(),
        tone: TextTone.onPrimary,
      ),
    );
  }

  Widget _buildDemoFeedback(String message, AppMessageBannerVariant variant) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSizes.messageMaxWidth),
      child: AppMessageBanner(message: message, variant: variant),
    );
  }

  Future<void> _confirmDemoDataLoad(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => _AdminHomeDemoDataDialog(
        title: LocaleKeys.demoData_confirmTitle.translate(),
        message: LocaleKeys.demoData_confirmMessage.translate(),
        actionLabel: LocaleKeys.demoData_confirmAction.translate(),
        actionTone: TextTone.onPrimary,
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await context.read<DemoDataCubit>().load();
  }

  Future<void> _confirmDemoDataClear(BuildContext context) async {
    final colors = context.colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => _AdminHomeDemoDataDialog(
        title: LocaleKeys.demoData_clearConfirmTitle.translate(),
        message: LocaleKeys.demoData_clearConfirmMessage.translate(),
        actionLabel: LocaleKeys.demoData_clearConfirmAction.translate(),
        actionTone: TextTone.onErrorContainer,
        actionStyle: FilledButton.styleFrom(
          backgroundColor: colors.errorContainer,
          foregroundColor: colors.onErrorContainer,
        ),
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await context.read<DemoDataCubit>().clear();
  }

  String _loadingMessage(DemoDataCommand command) {
    return switch (command) {
      DemoDataCommand.load => LocaleKeys.demoData_loading.translate(),
      DemoDataCommand.clear => LocaleKeys.demoData_clearLoading.translate(),
    };
  }

  String _successMessage(DemoDataCommand command) {
    return switch (command) {
      DemoDataCommand.load => LocaleKeys.demoData_success.translate(),
      DemoDataCommand.clear => LocaleKeys.demoData_clearSuccess.translate(),
    };
  }

  String _failureMessage(DemoDataFailure failure) {
    return switch (failure.command) {
      DemoDataCommand.load => failure.errorCode.message,
      DemoDataCommand.clear => LocaleKeys.demoData_clearFailure.translate(),
    };
  }
}
