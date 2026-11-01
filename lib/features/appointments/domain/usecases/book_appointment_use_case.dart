import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/core/usecases/use_case.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/models/appointment_booking_request.dart';
import 'package:clinic_appointment_system/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_booking_context.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_validator.dart';

/// Validates all booking rules against slots read within the transaction.
final class BookAppointmentUseCase
    implements UseCase<DataResult<Appointment>, AppointmentBookingRequest> {
  /// Injects persistence and the clock read on every transaction attempt.
  const BookAppointmentUseCase(this._repository, this._clock);

  final AppointmentRepository _repository;
  final Clock _clock;

  @override
  Future<DataResult<Appointment>> call(AppointmentBookingRequest request) {
    return _repository.book(request.candidate, (staffSlots, patientSlots) {
      return const AppointmentValidator.standard().validate(
        request.candidate,
        AppointmentBookingContext(
          staff: request.staff,
          service: request.service,
          availability: request.availability,
          branchHours: request.branchHours,
          staffSlots: staffSlots,
          patientSlots: patientSlots,
          now: _clock.now(),
        ),
      );
    });
  }
}
