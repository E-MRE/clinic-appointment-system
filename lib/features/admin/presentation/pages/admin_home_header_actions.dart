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
                _branchSelector(context, catalogState, selectedBranchId),
                _appointmentsButton(context),
                _buildDemoDataButton(context, demoState),
              ],
            ),
            if (demoState is DemoDataLoading)
              _buildDemoFeedback(
                LocaleKeys.demoData_loading.translate(),
                AppMessageBannerVariant.info,
              ),
            if (demoState is DemoDataSuccess)
              _buildDemoFeedback(
                LocaleKeys.demoData_success.translate(),
                AppMessageBannerVariant.highlight,
              ),
            if (demoState is DemoDataFailure)
              _buildDemoFeedback(
                demoState.errorCode.message,
                AppMessageBannerVariant.error,
              ),
          ],
        );
      },
    );
  }

  String? _branchId(String? value) {
    if (value == _allBranchesValue) return null;
    return value;
  }

  String get _allBranchesValue => '';

  Widget _branchSelector(
    BuildContext context,
    ClinicCatalogState catalogState,
    String? selectedBranchId,
  ) {
    return SizedBox(
      width: AdminLayoutConstants.overviewBranchSelectWidth,
      child: AppSelectField<String>(
        label: LocaleKeys.admin_appointmentsPage_branch.translate(),
        showLabel: false,
        enabled: catalogState is ClinicCatalogLoaded,
        value: selectedBranchId ?? _allBranchesValue,
        options: [
          AppSelectOption<String>(
            value: _allBranchesValue,
            label: LocaleKeys.admin_appointmentsPage_allBranches.translate(),
          ),
          if (catalogState is ClinicCatalogLoaded)
            for (final branch in catalogState.catalog.branches)
              AppSelectOption<String>(value: branch.id, label: branch.name),
        ],
        onChanged: (value) {
          context.read<AdminDashboardCubit>().selectBranch(_branchId(value));
        },
      ),
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

  FilledButton _buildDemoDataButton(BuildContext context, DemoDataState state) {
    final isLoading = state is DemoDataLoading;
    VoidCallback? onPressed;
    if (!isLoading) {
      onPressed = () {
        _confirmDemoDataLoad(context);
      };
    }
    return FilledButton.icon(
      onPressed: onPressed,
      icon: _buildDemoDataIcon(isLoading),
      label: AppText.label(
        LocaleKeys.demoData_loadButton.translate(),
        tone: TextTone.onPrimary,
      ),
    );
  }

  Widget _buildDemoDataIcon(bool isLoading) {
    if (isLoading) {
      return const SizedBox.square(
        dimension: AppSizes.s16,
        child: CircularProgressIndicator(),
      );
    }
    return const Icon(Icons.cloud_download_outlined);
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
      builder: (_) => const _AdminHomeDemoDataDialog(),
    );
    if (confirmed != true || !context.mounted) return;
    await context.read<DemoDataCubit>().load();
  }
}
