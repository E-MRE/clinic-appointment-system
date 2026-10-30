part of 'medical_services_page.dart';

/// Scrollable table or empty state placeholder for medical services on wide screens.
final class _MedicalServicesTablePanel extends StatelessWidget {
  const _MedicalServicesTablePanel({
    required this.services,
    required this.overview,
  });

  final List<MedicalService> services;
  final MedicalServiceListOverview overview;

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return _MedicalServicesDesktopEmpty(overview: overview);
    }
    return SingleChildScrollView(
      child: _MedicalServicesTable(services: services, overview: overview),
    );
  }
}
