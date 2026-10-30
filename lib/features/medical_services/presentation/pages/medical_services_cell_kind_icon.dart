part of 'medical_services_page.dart';

/// Rounded container holding a medical service kind's themed icon.
final class _MedicalServicesCellKindIcon extends StatelessWidget {
  const _MedicalServicesCellKindIcon({required this.kind});

  final MedicalServiceKind kind;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return Container(
      width: AppSizes.s40,
      height: AppSizes.s40,
      decoration: BoxDecoration(
        color: kind.containerColor(scheme),
        borderRadius: const AppRadius.medium(),
      ),
      alignment: Alignment.center,
      child: Icon(
        kind.icon,
        size: AppSizes.s20,
        color: kind.foregroundColor(scheme),
      ),
    );
  }
}
