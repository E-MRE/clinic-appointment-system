part of 'medical_services_page.dart';

/// Mobile layout displaying kind filter chips and department-grouped service cards.
final class _MedicalServicesMobileView extends StatelessWidget {
  const _MedicalServicesMobileView({
    required this.overview,
    required this.groups,
  });

  final MedicalServiceListOverview overview;
  final List<DepartmentServiceGroup> groups;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MedicalServicesFilterChipsRow(overview: overview),
        const EmptySize.s16Height(),
        Expanded(
          child: groups.isEmpty
              ? AppMutedMessage(message: LocaleKeys.services_filterEmpty.tr())
              : _MedicalServicesMobileList(groups: groups),
        ),
      ],
    );
  }
}
