part of 'medical_service_form.dart';

/// Form body wrapping input fields with Form state validation.
final class _MedicalServiceFormBody extends StatelessWidget {
  const _MedicalServiceFormBody({
    required this.formKey,
    required this.isEditing,
    required this.onSave,
    this.onCancel,
  });

  final GlobalKey<FormState> formKey;
  final bool isEditing;
  final VoidCallback onSave;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s16,
        children: [
          _MedicalServiceFormKindControl(isEditing: isEditing),
          const _MedicalServiceFormNameField(),
          _MedicalServiceFormDepartmentField(isEditing: isEditing),
          const _MedicalServiceFormDurationFeeRow(),
          const _MedicalServiceFormKindSection(),
          const _MedicalServiceFormSaveError(),
          _MedicalServiceFormActions(onSave: onSave, onCancel: onCancel),
        ],
      ),
    );
  }
}
