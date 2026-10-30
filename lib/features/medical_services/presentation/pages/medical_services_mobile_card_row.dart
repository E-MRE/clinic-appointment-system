part of 'medical_services_page.dart';

/// Content row of the mobile card showing kind icon, details and fee.
final class _MedicalServicesMobileCardRow extends StatelessWidget {
  const _MedicalServicesMobileCardRow({
    required this.service,
    required this.summary,
  });

  final MedicalService service;
  final MedicalServiceSummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MedicalServicesCellKindIcon(kind: service.kind),
        const EmptySize.s12Width(),
        Expanded(
          child: _MedicalServicesMobileCardDetails(
            name: service.name,
            summary: summary,
          ),
        ),
        const EmptySize.s8Width(),
        AppText.bodyStrong(service.fee.formatted(context)),
      ],
    );
  }
}
