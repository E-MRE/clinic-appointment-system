part of 'staff_form.dart';

/// Coordinates draft initialization, branch observers, controllers and saves.
mixin _StaffFormStateMixin on State<_StaffFormContent> {
  late GlobalKey<FormState> formKey;
  late final TextEditingController passwordController;
  late final StaffFormCubit formCubit;
  late final StaffSaveCubit saveCubit;
  late final DepartmentListCubit departmentCubit;
  late final MedicalServiceListCubit serviceCubit;
  late String _watchedBranchId;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    formCubit = context.read<StaffFormCubit>();
    saveCubit = context.read<StaffSaveCubit>();
    departmentCubit = context.read<DepartmentListCubit>();
    serviceCubit = context.read<MedicalServiceListCubit>();
    _startDraft();
    passwordController = TextEditingController(text: formCubit.state.password);
    _watchedBranchId = formCubit.state.branchId;
    _watchBranch(_watchedBranchId);
  }

  @override
  void didUpdateWidget(covariant _StaffFormContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.staff != widget.staff) {
      formKey = GlobalKey<FormState>();
      _startDraft();
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  /// Synchronizes generated passwords and watches only the current branch.
  void onValuesChanged(BuildContext context, StaffFormValues values) {
    if (passwordController.text != values.password) {
      passwordController.text = values.password;
    }
    if (_watchedBranchId != values.branchId) {
      _watchedBranchId = values.branchId;
      _watchBranch(values.branchId);
    }
  }

  /// Notifies the host and prepares another creation draft after success.
  void onSaveState(BuildContext context, StaffSaveState state) {
    if (state is! StaffSaveSaved) return;
    widget.onSaved?.call(state.staff);
    if (!mounted || widget.isEditing) return;
    setState(() {
      formKey = GlobalKey<FormState>();
      formCubit.startCreate();
    });
  }

  /// Validates fields and persists with the loaded catalogue of this branch.
  void submit() {
    final form = formKey.currentState;
    if (form == null || !form.validate()) return;
    final values = formCubit.state;
    final serviceState = serviceCubit.state;
    final availableServices = <MedicalService>[
      if (serviceState is InstitutionListLoaded<MedicalService>)
        for (final service in serviceState.items)
          if (service.branchId == values.branchId) service,
    ];
    if (widget.staff case final original?) {
      saveCubit.update(
        values,
        original: original,
        availableServices: availableServices,
      );
    } else {
      saveCubit.create(values, availableServices: availableServices);
    }
  }

  void _startDraft() {
    if (widget.staff case final staff?) {
      formCubit.startEdit(staff);
    } else {
      formCubit.startCreate();
    }
  }

  void _watchBranch(String branchId) {
    if (branchId.isEmpty) {
      departmentCubit.clear();
      serviceCubit.clear();
    } else {
      departmentCubit.watch(branchId);
      serviceCubit.watch(branchId);
    }
  }
}
