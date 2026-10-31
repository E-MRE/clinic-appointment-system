import 'package:clinic_appointment_system/core/states/record_editor_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';

/// Holds the medical service edit target and its form revision.
final class MedicalServiceEditorCubit
    extends RecordEditorCubit<MedicalService> {
  /// Creates an editor in creation mode at revision zero.
  MedicalServiceEditorCubit();
}
