import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';

/// Identifies a window to add to or remove from a staff schedule.
final class AvailabilityWindowRequest {
  /// Creates a request for [window] in [subject]'s schedule.
  const AvailabilityWindowRequest({
    required this.subject,
    required this.window,
  });

  /// The staff and branch owning the schedule.
  final AvailabilitySubject subject;

  /// The window to add or remove.
  final AvailabilityWindow window;
}
