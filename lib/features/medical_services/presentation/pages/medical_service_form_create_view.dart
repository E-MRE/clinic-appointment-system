part of 'medical_service_form_page.dart';

/// Full-page scaffold for creating a new medical service record on mobile.
final class _MedicalServiceFormCreateView extends StatelessWidget {
  const _MedicalServiceFormCreateView();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeader(title: LocaleKeys.services_addService.tr()),
            const EmptySize.s16Height(),
            MedicalServiceForm(onSaved: (_) => context.pop()),
          ],
        ),
      ),
    );
  }
}
