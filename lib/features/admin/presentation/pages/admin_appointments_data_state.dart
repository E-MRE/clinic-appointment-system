part of 'admin_appointments_page.dart';

/// Waits for both observations before displaying the filters and table.
final class _AdminAppointmentsDataState extends StatelessWidget {
  const _AdminAppointmentsDataState({
    required this.clock,
    required this.searchController,
    required this.onClearFilters,
  });

  final Clock clock;
  final TextEditingController searchController;
  final ValueChanged<BuildContext> onClearFilters;

  Widget _catalogFailure(BuildContext context) {
    return _AdminAppointmentsFailure(
      title: LocaleKeys.admin_appointmentsPage_catalogFailureTitle.translate(),
      message: LocaleKeys.admin_appointmentsPage_catalogFailureMessage
          .translate(),
      onRetry: context.read<ClinicCatalogCubit>().watch,
    );
  }

  Widget _appointmentsFailure(
    BuildContext context,
    AdminAppointmentsFailure state,
  ) {
    return _AdminAppointmentsFailure(
      title: LocaleKeys.admin_appointmentsPage_failureTitle.translate(),
      message: state.errorCode.message,
      onRetry: context.read<AdminAppointmentsCubit>().retry,
    );
  }

  Widget get _loading {
    return LoadingState(
      variant: LoadingStateVariant.skeletonList,
      label: LocaleKeys.admin_appointmentsPage_loading.translate(),
    );
  }

  Widget _sessionFailure(BuildContext context) {
    return _AdminAppointmentsFailure(
      title: LocaleKeys.admin_appointmentsPage_sessionFailureTitle.translate(),
      message: LocaleKeys.admin_appointmentsPage_sessionFailureMessage
          .translate(),
      onRetry: context.read<AdminAppointmentsCubit>().retry,
    );
  }

  Widget _loadedContent(
    BuildContext context,
    AdminAppointmentsLoaded appointmentsState,
    ClinicCatalogLoaded catalogState,
  ) {
    final actor = context.adminAppointmentActor;
    if (actor == null) return _sessionFailure(context);
    return _AdminAppointmentsLoadedContent(
      clock: clock,
      state: appointmentsState,
      catalog: catalogState.catalog,
      actor: actor,
      searchController: searchController,
      onClearFilters: onClearFilters,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminAppointmentsCubit, AdminAppointmentsState>(
      builder: (context, appointmentsState) {
        return BlocBuilder<ClinicCatalogCubit, ClinicCatalogState>(
          builder: (context, catalogState) {
            if (catalogState is ClinicCatalogFailure) {
              return _catalogFailure(context);
            }
            if (appointmentsState is AdminAppointmentsFailure) {
              return _appointmentsFailure(context, appointmentsState);
            }
            if (catalogState is! ClinicCatalogLoaded ||
                appointmentsState is! AdminAppointmentsLoaded) {
              return _loading;
            }
            return _loadedContent(context, appointmentsState, catalogState);
          },
        );
      },
    );
  }
}
