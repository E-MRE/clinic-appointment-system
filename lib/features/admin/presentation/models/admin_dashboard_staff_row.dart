import 'package:equatable/equatable.dart';

/// One staff member's count, location caption and normalized bar length.
final class AdminDashboardStaffRow extends Equatable {
  /// Creates a staff chart row.
  const AdminDashboardStaffRow({
    required this.fullName,
    required this.caption,
    required this.count,
    required this.fractionOfMaximum,
  });

  /// The staff member's full name.
  final String fullName;

  /// The department and branch joined for the dashboard caption.
  final String caption;

  /// The number of today's appointments assigned to the staff member.
  final int count;

  /// The count divided by the largest staff count, between zero and one.
  final double fractionOfMaximum;

  @override
  List<Object> get props => [fullName, caption, count, fractionOfMaximum];
}
