part of 'medical_services_page.dart';

/// Primary action button in the page header to navigate to the service creation form.
final class _MedicalServicesAddButton extends StatelessWidget {
  const _MedicalServicesAddButton();

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () => context.go(AppRoutes.serviceNew),
      icon: const Icon(Icons.add),
      label: AppText.label(
        LocaleKeys.services_addService.tr(),
        tone: TextTone.onPrimary,
      ),
    );
  }
}
