import 'package:clinic_appointment_system/core/usecases/no_params.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/usecases/watch_staff_use_case.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// Observes all staff profiles.
/// The shared list template maps UserException failures to the generic
/// InstitutionErrorCode.unavailable because they are not InstitutionException.
final class StaffListCubit
    extends InstitutionListCubit<Staff, NoParams, WatchStaffUseCase> {
  /// Injects the typed observation use case.
  StaffListCubit(super.watchUseCase);

  /// Starts or replaces the observation.
  Future<void> watch() => watchWith(const NoParams());
}
