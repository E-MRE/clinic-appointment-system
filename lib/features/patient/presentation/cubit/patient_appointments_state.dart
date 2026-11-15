import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_appointments_overview.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_department_summary.dart';

/// The closed set of states of the patient's appointment observation.
sealed class PatientAppointmentsState {
  /// Creates an appointment observation state.
  const PatientAppointmentsState();
}

/// Waiting for the first appointment list.
final class PatientAppointmentsLoading extends PatientAppointmentsState {
  /// Creates the loading state.
  const PatientAppointmentsLoading();
}

/// The observation failed with [errorCode].
final class PatientAppointmentsFailure extends PatientAppointmentsState {
  /// Creates the failure state identified by [errorCode].
  const PatientAppointmentsFailure(this.errorCode);

  /// The reason to localize at the presentation boundary.
  final AppointmentErrorCode errorCode;
}

/// The latest list of the patient's appointments.
final class PatientAppointmentsLoaded extends PatientAppointmentsState {
  /// Creates the loaded state holding source appointments and their derived
  /// overview and bookable departments.
  const PatientAppointmentsLoaded({
    required this.appointments,
    required this.overview,
    required this.bookableDepartments,
  });

  /// The patient's appointments in stored order.
  final List<Appointment> appointments;

  /// Joined and ordered appointment entries computed by the owning cubit.
  final PatientAppointmentsOverview overview;

  /// Departments with staff-bookable services, computed by the owning cubit.
  final List<PatientDepartmentSummary> bookableDepartments;
}
