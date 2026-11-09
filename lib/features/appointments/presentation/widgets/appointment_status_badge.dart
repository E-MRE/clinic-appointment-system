import 'package:clinic_appointment_system/core/widgets/status_badge/status_badge.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/appointment_status_presentation.dart';
import 'package:flutter/widgets.dart';

/// The shared status badge showing an appointment's lifecycle status.
final class AppointmentStatusBadge extends StatelessWidget {
  /// Creates a badge for [status].
  const AppointmentStatusBadge({required this.status, super.key});

  /// The lifecycle status to display.
  final AppointmentStatus status;

  @override
  Widget build(BuildContext context) {
    return StatusBadge(label: status.label, variant: status.badgeVariant);
  }
}
