part of 'department_section.dart';

/// Input and create control for a department.
final class _DepartmentAddRow extends StatelessWidget {
  const _DepartmentAddRow({required this.controller, required this.onAdd});

  final TextEditingController controller;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            label: LocaleKeys.institution_newDepartmentName.tr(),
            controller: controller,
          ),
        ),
        const EmptySize.s8Width(),
        FilledButton(
          onPressed: onAdd,
          child: AppText.label(
            LocaleKeys.institution_add.tr(),
            tone: TextTone.onPrimary,
          ),
        ),
      ],
    );
  }
}
