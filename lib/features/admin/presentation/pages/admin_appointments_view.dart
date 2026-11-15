part of 'admin_appointments_page.dart';

/// Keeps the title visible while appointment and catalog data load.
final class _AdminAppointmentsView extends StatelessWidget {
  const _AdminAppointmentsView({
    required this.clock,
    required this.searchController,
    required this.onClearFilters,
  });

  final Clock clock;
  final TextEditingController searchController;
  final ValueChanged<BuildContext> onClearFilters;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s20,
        children: [
          PageHeader(
            title: LocaleKeys.admin_appointmentsTitle.translate(),
            subtitle: LocaleKeys.admin_appointmentsSubtitle.translate(),
          ),
          _AdminAppointmentsDataState(
            clock: clock,
            searchController: searchController,
            onClearFilters: onClearFilters,
          ),
        ],
      ),
    );
  }
}
