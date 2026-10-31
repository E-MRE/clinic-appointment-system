import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';

/// Availability persistence boundary with atomic read-modify-write semantics.
/// Implementations must expose provider-independent [AvailabilityException]s.
abstract interface class StaffAvailabilityRepository {
  /// Implementations must watch [subject], emitting [StaffAvailability.empty]
  /// in a successful result when the document is missing.
  /// Stream failures must be [AvailabilityException] with unavailable or
  /// invalidRecord, rather than provider-specific errors.
  Stream<DataResult<StaffAvailability>> watch(AvailabilitySubject subject);

  /// Implementations must atomically read the current schedule, apply [change]
  /// and write its result in one transaction.
  /// An [AvailabilityException] thrown by [change] must propagate unchanged,
  /// with nothing written. Provider failures must become
  /// [AvailabilityException] with unavailable.
  Future<DataResult<StaffAvailability>> update(
    AvailabilitySubject subject,
    StaffAvailability Function(StaffAvailability current) change,
  );
}
