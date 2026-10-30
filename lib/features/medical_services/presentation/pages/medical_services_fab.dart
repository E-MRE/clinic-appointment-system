part of 'medical_services_page.dart';

/// Extended floating action button on mobile viewports for adding a service.
final class _MedicalServicesFab extends StatelessWidget {
  const _MedicalServicesFab();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => context.go(AppRoutes.serviceNew),
      icon: const Icon(Icons.add),
      label: AppText.label(
        LocaleKeys.services_addService.tr(),
        tone: TextTone.onPrimary,
      ),
      backgroundColor: context.colorScheme.primary,
      foregroundColor: context.colorScheme.onPrimary,
    );
  }
}
