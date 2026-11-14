part of 'admin_home_page.dart';

/// Resolves appointment, catalog and administrator state before showing data.
final class _AdminHomeDataState extends StatelessWidget {
  const _AdminHomeDataState({required this.clock});

  final Clock clock;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
      builder: (context, dashboardState) {
        return BlocBuilder<ClinicCatalogCubit, ClinicCatalogState>(
          builder: (context, catalogState) {
            if (catalogState is ClinicCatalogFailure) {
              return _AdminHomeFailureState(
                title: LocaleKeys.admin_overview_catalogFailureTitle
                    .translate(),
                message: LocaleKeys.admin_overview_catalogFailureMessage
                    .translate(),
                onRetry: context.read<ClinicCatalogCubit>().watch,
              );
            }
            if (dashboardState is AdminDashboardFailure) {
              return _AdminHomeFailureState(
                title: LocaleKeys.admin_overview_failureTitle.translate(),
                message: dashboardState.errorCode.message,
                onRetry: context.read<AdminDashboardCubit>().retry,
              );
            }
            if (catalogState is! ClinicCatalogLoaded ||
                dashboardState is! AdminDashboardLoaded) {
              return LoadingState(
                variant: LoadingStateVariant.skeletonList,
                label: LocaleKeys.admin_overview_loading.translate(),
              );
            }
            final actor = context.adminAppointmentActor;
            if (actor == null) {
              return _AdminHomeFailureState(
                title: LocaleKeys.admin_overview_sessionFailureTitle
                    .translate(),
                message: LocaleKeys.admin_overview_sessionFailureMessage
                    .translate(),
                onRetry: context.read<AdminDashboardCubit>().retry,
              );
            }
            return _AdminHomeLoadedContent(
              clock: clock,
              summary: dashboardState.summary,
              catalog: catalogState.catalog,
              actor: actor,
            );
          },
        );
      },
    );
  }
}
