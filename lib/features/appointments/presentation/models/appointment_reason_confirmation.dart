import 'package:equatable/equatable.dart';

/// User confirmation returned by [AppointmentReasonDialog].
final class AppointmentReasonConfirmation extends Equatable {
  /// Captures the confirmed reason.
  const AppointmentReasonConfirmation({this.reason});

  /// The user-supplied status change reason (trimmed, null when blank).
  final String? reason;

  @override
  List<Object?> get props => [reason];
}
