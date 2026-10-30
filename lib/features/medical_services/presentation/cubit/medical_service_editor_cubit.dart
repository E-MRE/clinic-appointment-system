import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_editor_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds the service being edited on the desktop panel and its revision counter.
final class MedicalServiceEditorCubit extends Cubit<MedicalServiceEditorState> {
  /// Creates an editor cubit in creation mode at revision zero.
  MedicalServiceEditorCubit() : super(const MedicalServiceEditorState());

  /// Resets the editor to create mode and increments the revision.
  void startCreate() {
    emit(
      MedicalServiceEditorState(service: null, revision: state.revision + 1),
    );
  }

  /// Sets [service] as the active edit target and increments the revision.
  void edit(MedicalService service) {
    emit(
      MedicalServiceEditorState(service: service, revision: state.revision + 1),
    );
  }

  /// Resets to create mode after a successful save or cancel.
  void reset() => startCreate();
}
