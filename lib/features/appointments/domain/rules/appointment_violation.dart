import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:equatable/equatable.dart';

/// A booking failure and, for overlaps, the conflicting appointment.
final class AppointmentViolation extends Equatable {
  /// Creates a violation with an optional conflicting appointment.
  const AppointmentViolation(this.code, {this.conflict});

  /// The reason the booking failed.
  final AppointmentErrorCode code;

  /// The existing appointment responsible for an overlap, if any.
  final Appointment? conflict;

  /// Values defining equality.
  @override
  List<Object?> get props => [code, conflict];
}
