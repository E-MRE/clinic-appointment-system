part of 'medical_service_form_page.dart';

/// Scaffold and header wrapping the edit form for an existing medical service.
final class _MedicalServiceFormEditBody extends StatelessWidget {
  const _MedicalServiceFormEditBody({required this.service});

  final MedicalService service;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeader(title: LocaleKeys.services_editService.tr()),
            const EmptySize.s16Height(),
            MedicalServiceForm(
              service: service,
              branchId: service.branchId,
              onSaved: (_) => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
