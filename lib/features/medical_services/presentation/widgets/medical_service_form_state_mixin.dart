part of 'medical_service_form.dart';

/// Owns the form key and cubits of [MedicalServiceForm] and dispatches saves.
mixin _MedicalServiceFormStateMixin on State<MedicalServiceForm> {
  late final GlobalKey<FormState> formKey;
  late final MedicalServiceFormCubit formCubit;
  late final MedicalServiceSaveCubit saveCubit;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    final initialValues =
        widget.service?.accept(const MedicalServiceFormValuesVisitor()) ??
        const MedicalServiceFormValues.empty();
    formCubit = AppDependency.injector.get<MedicalServiceFormCubit>()
      ..initialize(initialValues);
    saveCubit = AppDependency.injector.get<MedicalServiceSaveCubit>();
  }

  @override
  void dispose() {
    formCubit.close();
    saveCubit.close();
    super.dispose();
  }

  /// Dispatches the newly saved service to the caller on success.
  void onSaveState(
    BuildContext context,
    InstitutionSaveState<MedicalService> state,
  ) {
    if (state is InstitutionSaveSaved<MedicalService>) {
      widget.onSaved(state.value);
    }
  }

  /// Validates input fields and issues the persistence request through [saveCubit].
  void submit() {
    final form = formKey.currentState;
    if (form == null || !form.validate()) return;

    final branchId =
        widget.service?.branchId ??
        widget.branchId ??
        InstitutionSelectionScope.read(context).branchId;
    if (branchId == null) return;

    saveCubit.save(
      formCubit.state,
      branchId: branchId,
      original: widget.service,
    );
  }
}
