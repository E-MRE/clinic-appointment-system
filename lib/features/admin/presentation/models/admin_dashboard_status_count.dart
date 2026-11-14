import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_status_filter.dart';
import 'package:equatable/equatable.dart';

/// The number of today's appointments represented by one dashboard status.
final class AdminDashboardStatusCount extends Equatable {
  /// Creates one status segment and its legend count.
  const AdminDashboardStatusCount({required this.status, required this.count});

  /// The administrator status group represented by this row.
  final AdminStatusFilter status;

  /// The number of today's appointments in [status].
  final int count;

  @override
  List<Object> get props => [status, count];
}
