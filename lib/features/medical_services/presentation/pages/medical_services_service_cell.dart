part of 'medical_services_page.dart';

/// Service column cell: kind icon, name and the visitor's table subtitle.
final class _MedicalServicesServiceCell extends StatelessWidget {
  const _MedicalServicesServiceCell({required this.service});

  final MedicalService service;

  static const MedicalServiceSummaryVisitor _visitor =
      MedicalServiceSummaryVisitor();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSizes.s12,
      children: [
        _MedicalServicesCellKindIcon(kind: service.kind),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.bodyStrong(service.name),
              AppText.caption(
                service.accept(_visitor).tableSubtitle,
                tone: TextTone.muted,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
