import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/stream_use_case.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:clinic_appointment_system/features/availability/domain/repositories/staff_availability_repository.dart';

/// Observes one staff member's schedule at their assigned branch.
final class WatchStaffAvailabilityUseCase
    implements
        StreamUseCase<DataResult<StaffAvailability>, AvailabilitySubject> {
  /// Injects the availability observation boundary.
  const WatchStaffAvailabilityUseCase(this._repository);

  final StaffAvailabilityRepository _repository;

  /// Returns schedule changes and preserves repository stream failures.
  @override
  Stream<DataResult<StaffAvailability>> call(AvailabilitySubject subject) {
    return _repository.watch(subject);
  }
}
