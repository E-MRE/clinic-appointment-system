part of 'medical_services_page.dart';

/// Mobile layout displaying kind filter chips and department-grouped service cards.
final class _MedicalServicesMobileView extends StatelessWidget {
  const _MedicalServicesMobileView({
    required this.overview,
    required this.services,
  });

  final MedicalServiceListOverview overview;
  final List<MedicalService> services;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MedicalServicesFilterChipsRow(overview: overview),
        const EmptySize.s16Height(),
        Expanded(
          child: services.isEmpty
              ? const _MedicalServicesFilteredEmpty()
              : _MedicalServicesMobileList(
                  services: services,
                  overview: overview,
                ),
        ),
      ],
    );
  }
}
