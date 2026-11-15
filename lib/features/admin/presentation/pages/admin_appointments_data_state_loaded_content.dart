part of 'admin_appointments_page.dart';

/// Resolves the current admin actor before displaying loaded appointments.
final class _AdminAppointmentsDataLoadedContent extends StatelessWidget {
  /// Creates the loaded appointment content with its display dependencies.
  const _AdminAppointmentsDataLoadedContent({
    required this.clock,
    required this.appointmentsState,
    required this.catalogState,
    required this.searchController,
    required this.onClearFilters,
  });

  final Clock clock;
  final AdminAppointmentsLoaded appointmentsState;
  final ClinicCatalogLoaded catalogState;
  final TextEditingController searchController;
  final ValueChanged<BuildContext> onClearFilters;

  @override
  Widget build(BuildContext context) {
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

  Widget _sessionFailure(BuildContext context) {
    return _AdminAppointmentsFailure(
      title: LocaleKeys.admin_appointmentsPage_sessionFailureTitle.translate(),
      message: LocaleKeys.admin_appointmentsPage_sessionFailureMessage
          .translate(),
      onRetry: context.read<AdminAppointmentsCubit>().retry,
    );
  }
}
