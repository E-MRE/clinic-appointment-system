part of 'medical_services_page.dart';

/// Primary action button in the page header to navigate or open the service creation form.
final class _MedicalServicesAddButton extends StatelessWidget {
  const _MedicalServicesAddButton();

  @override
  Widget build(BuildContext context) {
    final branchId = InstitutionSelectionScope.of(context).branchId;

    return FilledButton.icon(
      onPressed: branchId == null ? null : () => _onAdd(context, branchId),
      icon: const Icon(Icons.add),
      label: AppText.label(
        LocaleKeys.services_addService.tr(),
        tone: TextTone.onPrimary,
      ),
    );
  }

  void _onAdd(BuildContext context, String branchId) {
    if (context.screenSize.isDesktop) {
      context.read<MedicalServiceEditorCubit>().startCreate();
    } else if (context.screenSize.isTablet) {
      _MedicalServiceFormDialog.show(context, branchId: branchId);
    } else {
      context.go(AppRoutes.serviceNew);
    }
  }
}
