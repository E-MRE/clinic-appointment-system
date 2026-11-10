import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/patient_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/errors/appointment_exception.dart';
import 'package:clinic_appointment_system/features/appointments/domain/models/appointment_booking_request.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/book_appointment_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/data_result_appointment_error_code.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/book_appointment_state.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/booking_selection.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_week_schedule.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Requests the chosen appointment for the signed-in patient, one request
/// at a time. The use case re-validates every booking rule inside its
/// transaction; results arriving after [close] are ignored.
final class BookAppointmentCubit extends Cubit<BookAppointmentState> {
  /// Injects the booking use case and the clock stamping the request.
  BookAppointmentCubit(this._book, this._clock)
    : super(const BookAppointmentIdle());

  final BookAppointmentUseCase _book;
  final Clock _clock;
  bool _isRequestInFlight = false;
  bool _isClosing = false;

  bool get _isClosingOrClosed => _isClosing || isClosed;

  /// Clears a displayed failure after the booking selection changes.
  void resetFailure() {
    if (state is BookAppointmentFailure) emit(const BookAppointmentIdle());
  }

  /// Requests the slot chosen in [selection] for [patient], with the
  /// availability and branch hours of [schedule]. Ignored while another
  /// request runs, while closing, or when the selection is incomplete.
  Future<void> submit({
    required BookingSelection selection,
    required StaffWeekSchedule schedule,
    required PatientAppointmentActor patient,
  }) async {
    if (_isClosingOrClosed || _isRequestInFlight) return;

    final service = selection.service;
    if (service == null) return;

    final staff = selection.staff;
    if (staff == null) return;

    final date = selection.date;
    if (date == null) return;

    final slot = selection.slot;
    if (slot == null) return;

    _isRequestInFlight = true;
    emit(const BookAppointmentInProgress());

    try {
      final result = await _book(
        AppointmentBookingRequest(
          candidate: Appointment.request(
            patientId: patient.id,
            staffId: staff.id,
            branchId: service.branchId,
            departmentId: service.departmentId,
            serviceId: service.id,
            serviceName: service.name,
            fee: service.fee,
            date: date,
            range: slot,
            by: patient,
            at: _clock.now(),
          ),
          staff: staff,
          service: service,
          availability: schedule.availability,
          branchHours: schedule.request.branchHours,
        ),
      );
      final appointment = result.data;
      if (result.isSuccess && appointment != null) {
        _emit(BookAppointmentSuccess(appointment));
        return;
      }
      _emit(BookAppointmentFailure(result.appointmentErrorCode));
    } on AppointmentException catch (error) {
      _emit(BookAppointmentFailure(error.code));
    } on Exception {
      _emit(const BookAppointmentFailure(AppointmentErrorCode.unavailable));
    } finally {
      _isRequestInFlight = false;
    }
  }

  void _emit(BookAppointmentState state) {
    if (_isClosingOrClosed) return;
    emit(state);
  }

  /// Closes the cubit and ignores any pending request completion.
  @override
  Future<void> close() async {
    _isClosing = true;
    await super.close();
  }
}
