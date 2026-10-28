part of 'department_section.dart';

/// Name field and validation feedback inside the edit dialog.
final class _DepartmentEditContent extends StatelessWidget {
  const _DepartmentEditContent({required this.controller, required this.state});

  final TextEditingController controller;
  final InstitutionSaveState<Department> state;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          label: LocaleKeys.institution_newDepartmentName.tr(),
          controller: controller,
        ),
        if (state is InstitutionSaveFailure<Department>)
          AppText.caption(
            (state as InstitutionSaveFailure<Department>).code.message,
            tone: TextTone.error,
          ),
      ],
    );
  }
}
