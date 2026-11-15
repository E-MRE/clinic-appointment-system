import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';

/// Provides the oldest request timestamp among appointments.
extension AppointmentOldestRequest on Iterable<Appointment> {
  /// The minimum first history timestamp, or null when this iterable is empty.
  DateTime? get oldestRequestedAt {
    DateTime? oldest;
    for (final appointment in this) {
      final requestedAt = appointment.history.first.at;
      if (oldest == null || requestedAt.compareTo(oldest) < 0) {
        oldest = requestedAt;
      }
    }
    return oldest;
  }
}
