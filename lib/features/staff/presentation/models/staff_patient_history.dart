import 'package:equatable/equatable.dart';

/// Stores the completed visit count and latest visit timestamp for a patient.
final class StaffPatientHistory extends Equatable {
  /// Creates a history from already-calculated values.
  const StaffPatientHistory({
    required this.completedCount,
    this.latestVisitDate,
  });

  /// Creates an empty history.
  const StaffPatientHistory.empty()
    : completedCount = 0,
      latestVisitDate = null;

  /// The total number of completed visits with this staff member.
  final int completedCount;

  /// The start date and time of the most recent completed visit, or null.
  final DateTime? latestVisitDate;

  @override
  List<Object?> get props => [completedCount, latestVisitDate];
}
