part of 'staff_form.dart';

/// Keeps the approved field order identical at every screen size.
final class _StaffFormBody extends StatelessWidget {
  const _StaffFormBody({
    required this.formKey,
    required this.passwordController,
    required this.isEditing,
    required this.onSave,
    this.onCancel,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
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
          _StaffFormRoleControl(isEditing: isEditing),
          const _StaffFormNameField(),
          const _StaffFormSpecialtySection(),
          _StaffFormEmailField(isEditing: isEditing),
          if (!isEditing)
            _StaffFormPasswordField(controller: passwordController),
          _StaffFormPlacementFields(isEditing: isEditing),
          const _StaffFormServices(),
          if (!isEditing) const _StaffFormPasswordHelp(),
          const _StaffFormSaveError(),
          _StaffFormActions(
            isEditing: isEditing,
            onSave: onSave,
            onCancel: onCancel,
          ),
        ],
      ),
    );
  }
}
