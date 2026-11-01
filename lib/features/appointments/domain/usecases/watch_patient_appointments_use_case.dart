import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/stream_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/repositories/appointment_repository.dart';

/// Observes owner-scoped appointment data for the presentation layer.
final class WatchPatientAppointmentsUseCase
    implements StreamUseCase<DataResult<List<Appointment>>, String> {
  /// Injects the appointment observation boundary.
  const WatchPatientAppointmentsUseCase(this._repository);

  final AppointmentRepository _repository;

  /// Preserves successful lists and error results from persistence.
  @override
  Stream<DataResult<List<Appointment>>> call(String params) {
    return _repository.watchPatientAppointments(params);
  }
}
