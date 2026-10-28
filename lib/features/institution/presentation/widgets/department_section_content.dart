part of 'department_section.dart';

/// Connects department actions to the section's request Cubit.
final class _DepartmentSectionContent extends StatefulWidget {
  const _DepartmentSectionContent({required this.branchId});

  final String branchId;

  @override
  State<_DepartmentSectionContent> createState() => _DepartmentSectionState();
}
