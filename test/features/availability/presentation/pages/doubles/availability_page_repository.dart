import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:clinic_appointment_system/features/availability/domain/repositories/staff_availability_repository.dart';

/// Controllable observation and atomic updates for the real availability use cases.
final class AvailabilityPageRepository implements StaffAvailabilityRepository {
  AvailabilityPageRepository(this.current);

  StaffAvailability current;
  final StreamController<DataResult<StaffAvailability>> events =
      StreamController.broadcast();
  int watchCalls = 0;
  int updateCalls = 0;
  Object? updateError;
  Completer<void>? updateGate;
  AvailabilitySubject? updatedSubject;

  @override
  Stream<DataResult<StaffAvailability>> watch(AvailabilitySubject subject) {
    watchCalls++;
    return events.stream;
  }

  @override
  Future<DataResult<StaffAvailability>> update(
    AvailabilitySubject subject,
    StaffAvailability Function(StaffAvailability) change,
  ) async {
    updateCalls++;
    updatedSubject = subject;
    await updateGate?.future;
    if (updateError case final error?) throw error;
    current = change(current);
    events.add(DataResult.success(data: current));
    return DataResult.success(data: current);
  }
}
