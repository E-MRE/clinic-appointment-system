part of 'medical_services_page.dart';

/// Primary action button in the page header to navigate or open the service creation form.
final class _MedicalServicesAddButton extends StatelessWidget {
  const _MedicalServicesAddButton();

  @override
  Widget build(BuildContext context) {
    final branchId = InstitutionSelectionScope.of(context).branchId;

    return FilledButton.icon(
      onPressed: branchId == null
          ? null
          : () => context.openServiceCreate(branchId),
      icon: const Icon(Icons.add),
      label: AppText.label(
        LocaleKeys.services_addService.tr(),
        tone: TextTone.onPrimary,
      ),
    );
  }
}
