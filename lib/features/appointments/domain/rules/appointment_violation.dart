import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';
import 'package:equatable/equatable.dart';

/// A booking failure and, for overlaps, the conflicting slot.
final class AppointmentViolation extends Equatable {
  /// Creates a violation with an optional conflicting slot.
  const AppointmentViolation(this.code, {this.conflict});

  /// The reason the booking failed.
  final AppointmentErrorCode code;

  /// The occupied slot responsible for an overlap, if any.
  final BookedSlot? conflict;

  /// Values defining equality.
  @override
  List<Object?> get props => [code, conflict];
}
