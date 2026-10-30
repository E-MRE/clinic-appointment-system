part of 'medical_services_page.dart';

/// Form body for the modal dialog hosting the header and medical service form.
final class _MedicalServicesFormDialogBody extends StatelessWidget {
  const _MedicalServicesFormDialogBody({
    required this.title,
    required this.branchId,
    this.service,
  });

  final String title;
  final String? branchId;
  final MedicalService? service;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MedicalServicesFormDialogHeader(title: title),
        const EmptySize.s16Height(),
        MedicalServiceForm(
          service: service,
          branchId: branchId,
          onCancel: () => Navigator.of(context).pop(),
          onSaved: (_) => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
