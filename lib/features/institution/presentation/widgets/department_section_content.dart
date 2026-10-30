part of 'department_section.dart';

/// Connects department actions to the section's request Cubit.
final class _DepartmentSectionContent extends StatefulWidget {
  const _DepartmentSectionContent({required this.branchId});

  final String branchId;

  @override
  State<_DepartmentSectionContent> createState() => _DepartmentSectionState();
}

final class _DepartmentSectionState extends State<_DepartmentSectionContent>
    with _DepartmentSectionStateMixin {
  @override
  Widget build(BuildContext context) {
    return AppSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText.sectionTitle(LocaleKeys.institution_departments.tr()),
          const EmptySize.s12Height(),
          const _DepartmentList(),
          const EmptySize.s12Height(),
          _DepartmentAddRow(controller: controller, onAdd: add),
          const _DepartmentSaveError(),
        ],
      ),
    );
  }
}
