part of 'medical_services_page.dart';

/// Department-grouped scrollable cards view for mobile screens.
final class _MedicalServicesMobileList extends StatelessWidget {
  const _MedicalServicesMobileList({required this.groups});

  final List<DepartmentServiceGroup> groups;

  @override
  Widget build(BuildContext context) {
    final formatter = AppDependency.injector
        .get<MedicalServiceOverviewFormatter>();
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
                child: AppText.sectionTitle(
                  group.departmentName ?? formatter.otherDepartmentName,
                ),
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
