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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminAppointmentsCubit, AdminAppointmentsState>(
      builder: (context, appointmentsState) {
        return BlocBuilder<ClinicCatalogCubit, ClinicCatalogState>(
          builder: (context, catalogState) {
            if (catalogState is ClinicCatalogFailure) {
              return _AdminAppointmentsFailure(
                title: LocaleKeys.admin_appointmentsPage_catalogFailureTitle
                    .translate(),
                message: LocaleKeys.admin_appointmentsPage_catalogFailureMessage
                    .translate(),
                onRetry: context.read<ClinicCatalogCubit>().watch,
              );
            }
            if (appointmentsState is AdminAppointmentsFailure) {
              return _AdminAppointmentsFailure(
                title: LocaleKeys.admin_appointmentsPage_failureTitle
                    .translate(),
                message: appointmentsState.errorCode.message,
                onRetry: context.read<AdminAppointmentsCubit>().retry,
              );
            }
            if (catalogState is! ClinicCatalogLoaded ||
                appointmentsState is! AdminAppointmentsLoaded) {
              return LoadingState(
                variant: LoadingStateVariant.skeletonList,
                label: LocaleKeys.admin_appointmentsPage_loading.translate(),
              );
            }
            final actor = context.adminAppointmentActor;
            if (actor == null) {
              return _AdminAppointmentsFailure(
                title: LocaleKeys.admin_appointmentsPage_sessionFailureTitle
                    .translate(),
                message: LocaleKeys.admin_appointmentsPage_sessionFailureMessage
                    .translate(),
                onRetry: context.read<AdminAppointmentsCubit>().retry,
              );
            }
            return _AdminAppointmentsLoadedContent(
              clock: clock,
              state: appointmentsState,
              catalog: catalogState.catalog,
              actor: actor,
              searchController: searchController,
              onClearFilters: onClearFilters,
            );
          },
        );
      },
    );
  }
}

/// Recoverable data failure with a retry for its owning observation.
final class _AdminAppointmentsFailure extends StatelessWidget {
  const _AdminAppointmentsFailure({
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ErrorState(
      title: title,
      message: message,
      icon: Icon(
        Icons.error_outline,
        color: context.colorScheme.onErrorContainer,
      ),
      iconBackground: context.colorScheme.errorContainer,
      primaryAction: FilledButton(
        onPressed: onRetry,
        child: AppText.label(
          LocaleKeys.admin_appointmentsPage_retry.translate(),
          tone: TextTone.onPrimary,
        ),
      ),
    );
  }
}
