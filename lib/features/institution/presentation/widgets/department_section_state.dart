part of 'department_section.dart';

/// Owns the department input and create request lifecycle.
mixin _DepartmentSectionStateMixin on State<_DepartmentSectionContent> {
  late final TextEditingController controller;
  late final DepartmentSaveCubit saveCubit;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    saveCubit = context.read<DepartmentSaveCubit>();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> add() async {
    if (controller.text.trim().isEmpty) return;
    await saveCubit.create(widget.branchId, controller.text.trim());
    if (mounted && saveCubit.state is InstitutionSaveSaved<Department>) {
      controller.clear();
    }
  }
}
