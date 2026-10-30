part of 'medical_services_page.dart';

/// Desktop two-column layout presenting services table and side editor panel.
final class _MedicalServicesDesktopLayout extends StatelessWidget {
  const _MedicalServicesDesktopLayout({
    required this.services,
    required this.overview,
  });

  final List<MedicalService> services;
  final MedicalServiceListOverview overview;

  @override
  Widget build(BuildContext context) {
    final tablePanel = _MedicalServicesTablePanel(
      services: services,
      overview: overview,
    );
    if (context.screenSize.isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSizes.s16,
        children: [
          Expanded(child: tablePanel),
          const _MedicalServicesDesktopPanel(),
        ],
      );
    }
    return tablePanel;
  }
}
