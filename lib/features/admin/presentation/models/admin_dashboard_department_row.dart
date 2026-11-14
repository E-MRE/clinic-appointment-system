import 'package:equatable/equatable.dart';

/// One department's count and normalized dashboard bar length.
final class AdminDashboardDepartmentRow extends Equatable {
  /// Creates a department chart row.
  const AdminDashboardDepartmentRow({
    required this.name,
    required this.count,
    required this.fractionOfMaximum,
  });

  /// The department's display name.
  final String name;

  /// The number of today's appointments in the department.
  final int count;

  /// The count divided by the largest department count, between zero and one.
  final double fractionOfMaximum;

  @override
  List<Object> get props => [name, count, fractionOfMaximum];
}
