part of 'staff_form.dart';

/// Owns form lifecycle beneath the provider-owned cubits.
final class _StaffFormContent extends StatefulWidget {
  const _StaffFormContent({this.staff, this.onCancel, this.onSaved});

  final Staff? staff;
  final VoidCallback? onCancel;
  final ValueChanged<Staff>? onSaved;

  bool get isEditing => staff != null;

  @override
  State<_StaffFormContent> createState() => _StaffFormContentState();
}

final class _StaffFormContentState extends State<_StaffFormContent>
    with _StaffFormStateMixin {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StaffFormCubit, StaffFormValues>(
          listener: onValuesChanged,
        ),
        BlocListener<StaffSaveCubit, StaffSaveState>(listener: onSaveState),
      ],
      child: _StaffFormBody(
        formKey: formKey,
        passwordController: passwordController,
        isEditing: widget.isEditing,
        onSave: submit,
        onCancel: widget.onCancel,
      ),
    );
  }
}
