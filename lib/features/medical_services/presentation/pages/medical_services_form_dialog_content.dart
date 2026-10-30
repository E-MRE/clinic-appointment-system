part of 'medical_services_page.dart';

/// Modal dialog body containing header actions and the medical service form.
final class _MedicalServiceFormDialogContent extends StatelessWidget {
  const _MedicalServiceFormDialogContent({
    required this.branchId,
    this.service,
  });

  final MedicalService? service;
  final String? branchId;

  double get _dialogWidth => 560;

  @override
  Widget build(BuildContext context) {
    final title = service != null
        ? LocaleKeys.services_editService.tr()
        : LocaleKeys.services_addService.tr();

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: _dialogWidth),
      child: Padding(
        padding: const AppPadding.allLg(),
        child: SingleChildScrollView(
          child: _MedicalServicesFormDialogBody(
            title: title,
            branchId: branchId,
            service: service,
          ),
        ),
      ),
    );
  }
}
