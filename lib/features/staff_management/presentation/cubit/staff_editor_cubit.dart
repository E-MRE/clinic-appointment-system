import 'package:clinic_appointment_system/core/states/record_editor_cubit.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// Holds the staff edit target and its form revision.
final class StaffEditorCubit extends RecordEditorCubit<Staff> {
  /// Creates an editor in creation mode at revision zero.
  StaffEditorCubit();
}
