part of 'medical_services_page.dart';

/// Modal dialog hosted on tablet screens for creating and editing medical services.
final class _MedicalServiceFormDialog extends StatelessWidget {
  const _MedicalServiceFormDialog({required this.branchId, this.service});

  final MedicalService? service;
  final String branchId;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: _MedicalServiceFormDialogContent(
        service: service,
        branchId: branchId,
      ),
    );
  }
}
