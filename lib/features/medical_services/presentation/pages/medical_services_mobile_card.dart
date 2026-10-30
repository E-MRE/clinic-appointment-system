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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MedicalServicesCellKindIcon(kind: service.kind),
            const EmptySize.s12Width(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText.bodyStrong(service.name),
                  const EmptySize.s4Height(),
                  AppText.caption(summary.typeLine, tone: TextTone.muted),
                  const EmptySize.s2Height(),
                  AppText.caption(summary.detail, tone: TextTone.muted),
                ],
              ),
            ),
            const EmptySize.s8Width(),
            AppText.bodyStrong(service.fee.formatted(context)),
          ],
        ),
      ),
    );
  }
}
