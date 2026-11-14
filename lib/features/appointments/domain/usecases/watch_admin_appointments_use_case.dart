import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/stream_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/models/admin_appointments_query.dart';
import 'package:clinic_appointment_system/features/appointments/domain/repositories/appointment_repository.dart';

/// Observes appointments across all staff within an inclusive date range.
final class WatchAdminAppointmentsUseCase
    implements
        StreamUseCase<DataResult<List<Appointment>>, AdminAppointmentsQuery> {
  /// Injects the appointment observation boundary.
  const WatchAdminAppointmentsUseCase(this._repository);

  final AppointmentRepository _repository;

  /// Preserves successful lists and error results from persistence.
  @override
  Stream<DataResult<List<Appointment>>> call(AdminAppointmentsQuery params) {
    return _repository.watchAdminAppointments(params.from, params.through);
  }
}
