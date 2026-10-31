part of 'medical_services_page.dart';

/// Builds the service form inside the shared dialog.
final class _MedicalServiceFormDialog extends StatelessWidget {
  const _MedicalServiceFormDialog({required this.branchId, this.service});
  final MedicalService? service;
  final String branchId;
  @override
  Widget build(BuildContext context) {
    final title = service != null
        ? LocaleKeys.services_editService.tr()
        : LocaleKeys.services_addService.tr();
    return AppFormDialog(
      title: title,
      child: MedicalServiceForm(
        service: service,
        branchId: branchId,
        onCancel: () => Navigator.of(context).pop(),
        onSaved: (_) => Navigator.of(context).pop(),
      ),
    );
  }
}
