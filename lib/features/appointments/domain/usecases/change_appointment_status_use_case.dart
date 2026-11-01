import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/core/usecases/use_case.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action_transition.dart';
import 'package:clinic_appointment_system/features/appointments/domain/models/appointment_status_request.dart';
import 'package:clinic_appointment_system/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:clinic_appointment_system/features/appointments/domain/results/appointment_result.dart';

/// Applies lifecycle permissions and time limits to the stored appointment.
final class ChangeAppointmentStatusUseCase
    implements UseCase<AppointmentResult, AppointmentStatusRequest> {
  /// Injects atomic persistence and the clock evaluated on every attempt.
  const ChangeAppointmentStatusUseCase(this._repository, this._clock);

  final AppointmentRepository _repository;
  final Clock _clock;

  @override
  Future<AppointmentResult> call(AppointmentStatusRequest request) {
    return _repository.changeStatus(request.appointmentId, (current) {
      return request.action.apply(current, by: request.by, at: _clock.now());
    });
  }
}
