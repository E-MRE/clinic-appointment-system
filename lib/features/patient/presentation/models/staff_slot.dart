import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:equatable/equatable.dart';

/// One generated appointment slot and whether an appointment occupies it.
final class StaffSlot extends Equatable {
  /// Creates a slot over [range].
  const StaffSlot({required this.range, required this.isTaken});

  /// The slot's time range.
  final TimeRange range;

  /// Whether an occupying appointment overlaps the slot.
  final bool isTaken;

  /// Whether the slot can be requested.
  bool get isFree => !isTaken;

  @override
  List<Object> get props => [range, isTaken];
}
