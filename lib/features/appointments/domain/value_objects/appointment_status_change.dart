import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';

import 'package:equatable/equatable.dart';

/// An immutable record of who moved an appointment into a status and when.
final class AppointmentStatusChange extends Equatable {
  /// Records one successful lifecycle operation.
  const AppointmentStatusChange({
    required this.status,
    required this.byUserId,
    required this.byRole,
    required this.at,
  });

  /// The status reached by this operation.
  final AppointmentStatus status;

  /// The actor's user identifier.
  final String byUserId;

  /// The actor's role at the time of the operation.
  final UserRole byRole;

  /// The moment explicitly supplied by the caller.
  final DateTime at;

  /// All audit values defining equality.
  @override
  List<Object> get props => [status, byUserId, byRole, at];
}
