import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/core/time/clock_today.dart';
import 'package:clinic_appointment_system/core/usecases/use_case.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_window_request.dart';
import 'package:clinic_appointment_system/features/availability/domain/repositories/staff_availability_repository.dart';

/// Atomically removes a window while pruning expired dated windows.
final class RemoveAvailabilityWindowUseCase
    implements
        UseCase<DataResult<StaffAvailability>, AvailabilityWindowRequest> {
  /// Injects schedule persistence and the clock used inside each update attempt.
  const RemoveAvailabilityWindowUseCase(this._repository, this._clock);

  final StaffAvailabilityRepository _repository;
  final Clock _clock;

  /// Prunes the current schedule and removes the requested window by value.
  /// An absent window propagates the domain's windowNotFound failure.
  @override
  Future<DataResult<StaffAvailability>> call(
    AvailabilityWindowRequest request,
  ) {
    return _repository.update(request.subject, (current) {
      final today = _clock.today;
      return current.prunedBy(today).removing(request.window);
    });
  }
}
