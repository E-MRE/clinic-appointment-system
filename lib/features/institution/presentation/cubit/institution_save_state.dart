import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';

part 'institution_save_failure.dart';
part 'institution_save_initial.dart';
part 'institution_save_saved.dart';
part 'institution_save_saving.dart';

/// The closed set of states emitted by institution create and update requests.
sealed class InstitutionSaveState<T> {
  /// Creates a request state shared by the progress and result variants.
  const InstitutionSaveState();
}
