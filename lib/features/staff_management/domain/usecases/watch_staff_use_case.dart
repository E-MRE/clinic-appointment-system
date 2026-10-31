import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/core/usecases/no_params.dart';
import 'package:clinic_appointment_system/core/usecases/stream_use_case.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/repositories/staff_repository.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// Observes every doctor and technician profile.
final class WatchStaffUseCase
    implements StreamUseCase<DataResult<List<Staff>>, NoParams> {
  /// Injects the staff profile observation boundary.
  const WatchStaffUseCase(this._repository);

  final StaffRepository _repository;

  /// Returns staff changes. Failures are [UserException] stream errors;
  /// setup failures can throw synchronously.
  @override
  Stream<DataResult<List<Staff>>> call(NoParams params) {
    return _repository.watchStaff();
  }
}
