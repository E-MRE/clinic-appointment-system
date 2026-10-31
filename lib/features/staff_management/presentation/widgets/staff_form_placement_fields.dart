part of 'staff_form.dart';

/// Stacks placement on mobile and pairs the selects on wider screens.
final class _StaffFormPlacementFields extends StatelessWidget {
  const _StaffFormPlacementFields({required this.isEditing});

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    if (context.screenSize.isMobile) {
      return Column(
        spacing: AppSizes.s16,
        children: [
          _StaffFormBranchField(isEditing: isEditing),
          _StaffFormDepartmentField(isEditing: isEditing),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSizes.s12,
      children: [
        Expanded(child: _StaffFormBranchField(isEditing: isEditing)),
        Expanded(child: _StaffFormDepartmentField(isEditing: isEditing)),
      ],
    );
  }
}
