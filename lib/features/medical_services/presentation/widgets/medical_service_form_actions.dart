part of 'medical_service_form.dart';

/// Save button, preceded by a cancel button when the host offers one.
final class _MedicalServiceFormActions extends StatelessWidget {
  const _MedicalServiceFormActions({required this.onSave, this.onCancel});

  final VoidCallback onSave;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    if (onCancel != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: AppSizes.s8,
        children: [
          _MedicalServiceFormCancelButton(onCancel: onCancel!),
          _MedicalServiceFormSaveButton(onSave: onSave),
        ],
      );
    }
    return SizedBox(
      width: double.infinity,
      child: _MedicalServiceFormSaveButton(onSave: onSave),
    );
  }
}
