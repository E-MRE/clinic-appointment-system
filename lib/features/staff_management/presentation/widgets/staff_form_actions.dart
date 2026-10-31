part of 'staff_form.dart';

/// Pairs optional cancellation with the mode-specific save action.
final class _StaffFormActions extends StatelessWidget {
  const _StaffFormActions({
    required this.isEditing,
    required this.onSave,
    this.onCancel,
  });

  final bool isEditing;
  final VoidCallback onSave;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    if (onCancel case final cancel?) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: AppSizes.s8,
        children: [
          _StaffFormCancelButton(onCancel: cancel),
          Flexible(
            child: _StaffFormSaveButton(isEditing: isEditing, onSave: onSave),
          ),
        ],
      );
    }
    return SizedBox(
      width: double.infinity,
      child: _StaffFormSaveButton(isEditing: isEditing, onSave: onSave),
    );
  }
}
