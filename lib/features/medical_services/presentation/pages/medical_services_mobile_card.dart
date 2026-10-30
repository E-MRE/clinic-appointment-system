part of 'medical_services_page.dart';

/// Touch-friendly card representing a single medical service on mobile.
final class _MedicalServicesMobileCard extends StatelessWidget {
  const _MedicalServicesMobileCard({required this.service});

  final MedicalService service;

  static const MedicalServiceSummaryVisitor _visitor =
      MedicalServiceSummaryVisitor();

  @override
  Widget build(BuildContext context) {
    final summary = service.accept(_visitor);

    return AppSurface(
      padding: AppSurfacePadding.compact,
      child: InkWell(
        onTap: () => context.go(AppRoutes.serviceEdit(service.id)),
        child: _MedicalServicesMobileCardRow(
          service: service,
          summary: summary,
        ),
      ),
    );
  }
}
