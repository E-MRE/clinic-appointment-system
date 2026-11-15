import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_status_filter.dart';

/// Resolves initial administrator status filters from a route URI.
extension AdminAppointmentRouteQuery on Uri {
  /// Status groups selected by the route query, if recognized.
  Set<AdminStatusFilter> get initialAdminAppointmentStatuses {
    final statusValue =
        queryParameters[AppRoutes.adminAppointmentStatusParameter];
    if (statusValue == AppRoutes.adminPendingStatusValue) {
      return const {AdminStatusFilter.pending};
    }
    return const {};
  }
}
