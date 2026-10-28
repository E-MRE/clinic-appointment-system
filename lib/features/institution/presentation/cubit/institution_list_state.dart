import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';

part 'institution_list_failure.dart';
part 'institution_list_loaded.dart';
part 'institution_list_loading.dart';

/// The closed set of states emitted while an institution list is observed.
sealed class InstitutionListState<T> {
  /// Creates a list state shared by the loading, loaded and failure variants.
  const InstitutionListState();
}
