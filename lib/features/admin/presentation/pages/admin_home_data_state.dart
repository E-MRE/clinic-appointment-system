part of 'admin_home_page.dart';

/// Resolves appointment, catalog and administrator state before showing data.
final class _AdminHomeDataState extends StatelessWidget {
  const _AdminHomeDataState({required this.clock});

  final Clock clock;

  Widget _catalogFailure(BuildContext context) {
    return _AdminHomeFailureState(
      title: LocaleKeys.admin_overview_catalogFailureTitle.translate(),
      message: LocaleKeys.admin_overview_catalogFailureMessage.translate(),
      onRetry: context.read<ClinicCatalogCubit>().watch,
    );
  }

  Widget _dashboardFailure(BuildContext context, AdminDashboardFailure state) {
    return _AdminHomeFailureState(
      title: LocaleKeys.admin_overview_failureTitle.translate(),
      message: state.errorCode.message,
      onRetry: context.read<AdminDashboardCubit>().retry,
    );
  }

  Widget get _loading {
    return LoadingState(
      variant: LoadingStateVariant.skeletonList,
      label: LocaleKeys.admin_overview_loading.translate(),
    );
  }

  Widget _sessionFailure(BuildContext context) {
    return _AdminHomeFailureState(
      title: LocaleKeys.admin_overview_sessionFailureTitle.translate(),
      message: LocaleKeys.admin_overview_sessionFailureMessage.translate(),
      onRetry: context.read<AdminDashboardCubit>().retry,
    );
  }

  Widget _loadedContent(
    BuildContext context,
    AdminDashboardLoaded dashboardState,
    ClinicCatalogLoaded catalogState,
  ) {
    final actor = context.adminAppointmentActor;
    if (actor == null) return _sessionFailure(context);
    return _AdminHomeLoadedContent(
      clock: clock,
      summary: dashboardState.summary,
      catalog: catalogState.catalog,
      actor: actor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
      builder: (context, dashboardState) {
        return BlocBuilder<ClinicCatalogCubit, ClinicCatalogState>(
          builder: (context, catalogState) {
            if (catalogState is ClinicCatalogFailure) {
              return _catalogFailure(context);
            }
            if (dashboardState is AdminDashboardFailure) {
              return _dashboardFailure(context, dashboardState);
            }
            if (catalogState is! ClinicCatalogLoaded ||
                dashboardState is! AdminDashboardLoaded) {
              return _loading;
            }
            return _loadedContent(context, dashboardState, catalogState);
          },
        );
      },
    );
  }
}
