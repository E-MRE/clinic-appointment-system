part of 'medical_service_form.dart';

/// State lifecycle and persistence dispatch helpers for [MedicalServiceForm].
mixin _MedicalServiceFormStateMixin on State<MedicalServiceForm> {
  /// Underlying form key validating input controls.
  GlobalKey<FormState> get formKey;

  /// Cubit holding interactive form values.
  MedicalServiceFormCubit get formCubit;

  /// Cubit managing persistence requests.
  MedicalServiceSaveCubit get saveCubit;

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
