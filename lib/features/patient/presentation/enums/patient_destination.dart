import 'package:clinic_appointment_system/core/router/app_routes.dart';

/// Destinations available to a signed-in patient.
enum PatientDestination {
  /// The patient's own appointments.
  appointments(AppRoutes.patientAppointments),

  /// Booking a new appointment.
  book(AppRoutes.patientBook);

  const PatientDestination(this.route);

  /// The destination's absolute location.
  final String route;
}
