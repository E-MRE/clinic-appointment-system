part of 'medical_services_page.dart';

/// Middle text section of the mobile card showing service name, category and details.
final class _MedicalServicesMobileCardDetails extends StatelessWidget {
  const _MedicalServicesMobileCardDetails({
    required this.name,
    required this.summary,
  });

  final String name;
  final MedicalServiceSummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText.bodyStrong(name),
        const EmptySize.s4Height(),
        AppText.caption(summary.typeLine, tone: TextTone.muted),
        const EmptySize.s2Height(),
        AppText.caption(summary.detail, tone: TextTone.muted),
      ],
    );
  }
}
