import 'package:clinic_appointment_system/features/admin/presentation/models/admin_dashboard_summary.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';

/// The closed set of loading, failure and ready states for the admin dashboard.
sealed class AdminDashboardState {
  /// Creates an admin dashboard state.
  const AdminDashboardState();
}

/// The dashboard is waiting for appointment data or its clinic catalog.
final class AdminDashboardLoading extends AdminDashboardState {
  /// Creates the initial or retry loading state.
  const AdminDashboardLoading();
}

/// At least one appointment observation failed.
final class AdminDashboardFailure extends AdminDashboardState {
  /// Creates a failure state with the appointment error to localize.
  const AdminDashboardFailure(this.errorCode);

  /// The cause of the failed appointment observation.
  final AppointmentErrorCode errorCode;
}

/// Both appointment observations and the clinic catalog are available.
final class AdminDashboardLoaded extends AdminDashboardState {
  /// Creates the current dashboard state.
  const AdminDashboardLoaded(this.summary);

  /// The latest summary for the selected branch.
  final AdminDashboardSummary summary;
}
