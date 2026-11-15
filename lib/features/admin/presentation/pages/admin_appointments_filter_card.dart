part of 'admin_appointments_page.dart';

/// Groups the four narrowing fields with the multi-select status filters.
final class _AdminAppointmentsFilterCard extends StatelessWidget {
  const _AdminAppointmentsFilterCard({
    required this.filter,
    required this.catalog,
    required this.searchController,
    required this.onClearFilters,
  });

  final AdminAppointmentFilter filter;
  final ClinicCatalog catalog;
  final TextEditingController searchController;
  final ValueChanged<BuildContext> onClearFilters;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      padding: AppSurfacePadding.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s16,
        children: [
          _AdminAppointmentsFilterFields(filter: filter, catalog: catalog),
          _AdminAppointmentsFilterStatuses(
            filter: filter,
            onClearFilters: onClearFilters,
          ),
        ],
      ),
    );
  }
}
