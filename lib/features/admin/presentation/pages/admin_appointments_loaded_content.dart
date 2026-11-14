part of 'admin_appointments_page.dart';

/// Composes the appointment filters and their matching result table.
final class _AdminAppointmentsLoadedContent extends StatelessWidget {
  const _AdminAppointmentsLoadedContent({
    required this.clock,
    required this.state,
    required this.catalog,
    required this.actor,
    required this.searchController,
    required this.onClearFilters,
  });

  final Clock clock;
  final AdminAppointmentsLoaded state;
  final ClinicCatalog catalog;
  final AdminAppointmentActor actor;
  final TextEditingController searchController;
  final ValueChanged<BuildContext> onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s20,
      children: [
        _AdminAppointmentsFilterCard(
          filter: state.filter,
          catalog: catalog,
          searchController: searchController,
          onClearFilters: onClearFilters,
        ),
        _AdminAppointmentsTable(
          clock: clock,
          state: state,
          catalog: catalog,
          actor: actor,
          searchController: searchController,
        ),
      ],
    );
  }
}
