import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:clinic_appointment_system/features/availability/domain/repositories/staff_availability_repository.dart';

/// One controllable availability stream per staff member.
final class PatientAvailabilityRepository
    implements StaffAvailabilityRepository {
  final Map<String, StreamController<DataResult<StaffAvailability>>>
  _controllers = {};

  /// Subjects in the order they were watched.
  final List<AvailabilitySubject> watched = [];

  StreamController<DataResult<StaffAvailability>> _controller(String id) {
    return _controllers.putIfAbsent(id, StreamController.broadcast);
  }

  @override
  Stream<DataResult<StaffAvailability>> watch(AvailabilitySubject subject) {
    watched.add(subject);
    return _controller(subject.staffId).stream;
  }

  /// Emits [availability] on its staff member's stream.
  void emit(StaffAvailability availability) {
    _controller(
      availability.staffId,
    ).add(DataResult.success(data: availability));
  }

  /// Emits a failed result on [staffId]'s stream.
  void emitFailure(String staffId) {
    _controller(staffId).add(const DataResult.error());
  }

  /// Whether [staffId]'s stream currently has a subscriber.
  bool isWatched(String staffId) => _controller(staffId).hasListener;

  @override
  Future<DataResult<StaffAvailability>> update(
    AvailabilitySubject subject,
    StaffAvailability Function(StaffAvailability current) change,
  ) => throw UnimplementedError();

  /// Closes every controller.
  Future<void> close() async {
    for (final controller in _controllers.values) {
      await controller.close();
    }
  }
}
