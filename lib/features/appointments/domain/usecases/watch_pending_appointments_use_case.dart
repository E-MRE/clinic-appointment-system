import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/no_params.dart';
import 'package:clinic_appointment_system/core/usecases/stream_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/repositories/appointment_repository.dart';

/// Observes pending appointments across all staff and dates.
final class WatchPendingAppointmentsUseCase
    implements StreamUseCase<DataResult<List<Appointment>>, NoParams> {
  /// Injects the appointment observation boundary.
  const WatchPendingAppointmentsUseCase(this._repository);

  final AppointmentRepository _repository;

  /// Preserves successful lists and error results from persistence.
  @override
  Stream<DataResult<List<Appointment>>> call(NoParams params) {
    return _repository.watchPendingAppointments();
  }
}
