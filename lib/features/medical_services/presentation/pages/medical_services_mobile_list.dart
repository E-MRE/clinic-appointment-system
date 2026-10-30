part of 'medical_services_page.dart';

/// Department-grouped scrollable cards view for mobile screens.
final class _MedicalServicesMobileList extends StatelessWidget {
  const _MedicalServicesMobileList({
    required this.services,
    required this.overview,
  });

  final List<MedicalService> services;
  final MedicalServiceListOverview overview;

  @override
  Widget build(BuildContext context) {
    final groups = overview.groupServices(services);
    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return Padding(
          padding: const AppPadding.verticalSm(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const AppPadding.verticalSm(),
                child: AppText.sectionTitle(group.departmentName),
              ),
              const EmptySize.s4Height(),
              for (final service in group.services) ...[
                _MedicalServicesMobileCard(service: service),
                const EmptySize.s8Height(),
              ],
            ],
          ),
        );
      },
    );
  }
}
