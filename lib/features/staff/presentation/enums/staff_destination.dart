import 'package:clinic_appointment_system/core/router/app_routes.dart';

/// Destinations available to signed-in staff.
enum StaffDestination {
  /// Pending appointment requests awaiting approval.
  requests(AppRoutes.staffRequests),

  /// Weekly and dated appointment availability.
  availability(AppRoutes.staffAvailability);

  const StaffDestination(this.route);

  /// The destination's absolute location.
  final String route;
}
