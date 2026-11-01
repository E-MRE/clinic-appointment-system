import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:clinic_appointment_system/features/availability/domain/repositories/staff_availability_repository.dart';

/// Runs transaction changes before persisting, so rejected changes never write.
final class FakeStaffAvailabilityRepository
    implements StaffAvailabilityRepository {
  FakeStaffAvailabilityRepository(this.current);

  StaffAvailability current;
  Stream<DataResult<StaffAvailability>> stream = const Stream.empty();
  AvailabilitySubject? watchedSubject;
  AvailabilitySubject? updatedSubject;
  DataResult<StaffAvailability>? updateResult;
  Object? updateError;
  Future<void>? updateGate;
  int updateCalls = 0;
  int writes = 0;

  @override
  Stream<DataResult<StaffAvailability>> watch(AvailabilitySubject subject) {
    watchedSubject = subject;
    return stream;
  }

  @override
  Future<DataResult<StaffAvailability>> update(
    AvailabilitySubject subject,
    StaffAvailability Function(StaffAvailability current) change,
  ) async {
    updateCalls++;
    updatedSubject = subject;
    await updateGate;
    if (updateError case final error?) {
      throw error;
    }
    if (updateResult case final result?) {
      return result;
    }
    final next = change(current);
    current = next;
    writes++;
    return DataResult.success(data: next);
  }
}
