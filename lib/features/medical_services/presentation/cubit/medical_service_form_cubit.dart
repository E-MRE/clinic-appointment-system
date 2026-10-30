import 'package:clinic_appointment_system/features/medical_services/domain/enums/lab_result_time.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/models/medical_service_form_values.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages interactive form fields and draft values for a medical service.
final class MedicalServiceFormCubit extends Cubit<MedicalServiceFormValues> {
  /// Creates the form cubit with [state].
  MedicalServiceFormCubit([
    super.state = const MedicalServiceFormValues.empty(),
  ]);

  /// Replaces the current state with [values].
  void initialize(MedicalServiceFormValues values) => emit(values);

  /// Updates the selected medical service kind.
  void selectKind(MedicalServiceKind kind) {
    emit(state.copyWith(kind: kind));
  }

  /// Updates the service name.
  void changeName(String name) {
    emit(state.copyWith(name: name));
  }

  /// Updates the assigned department identifier.
  void selectDepartment(String departmentId) {
    emit(state.copyWith(departmentId: departmentId));
  }

  /// Updates the duration input text.
  void changeDuration(String durationText) {
    emit(state.copyWith(durationText: durationText));
  }

  /// Updates the fee input text.
  void changeFee(String feeText) {
    emit(state.copyWith(feeText: feeText));
  }

  /// Updates the selected imaging modality for radiology services.
  void selectModality(RadiologyModality modality) {
    emit(state.copyWith(modality: modality));
  }

  /// Updates the patient preparation note for radiology services.
  void changeNote(String note) {
    emit(state.copyWith(preparationNote: note));
  }

  /// Toggles whether fasting is required for laboratory tests.
  void toggleFasting(bool requiresFasting) {
    emit(state.copyWith(requiresFasting: requiresFasting));
  }

  /// Updates the fasting hours input text for laboratory tests.
  void changeFasting(String fastingText) {
    emit(state.copyWith(fastingText: fastingText));
  }

  /// Updates the result turnaround time for laboratory tests.
  void selectResultTime(LabResultTime resultTime) {
    emit(state.copyWith(resultTime: resultTime));
  }
}
