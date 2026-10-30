/// What a user role may do in the appointment workflow.
final class RolePermissions {
  /// A patient books appointments.
  const RolePermissions.patient()
    : canBookAppointments = true,
      canApproveAppointments = false,
      canMarkNoShow = false,
      canManageClinic = false,
      canViewAllAppointments = false;

  /// A doctor approves appointments and marks no-shows.
  const RolePermissions.doctor()
    : canBookAppointments = false,
      canApproveAppointments = true,
      canMarkNoShow = true,
      canManageClinic = false,
      canViewAllAppointments = false;

  /// A technician approves appointments.
  const RolePermissions.technician()
    : canBookAppointments = false,
      canApproveAppointments = true,
      canMarkNoShow = false,
      canManageClinic = false,
      canViewAllAppointments = false;

  /// An administrator manages the clinic and sees every appointment.
  const RolePermissions.admin()
    : canBookAppointments = false,
      canApproveAppointments = false,
      canMarkNoShow = false,
      canManageClinic = true,
      canViewAllAppointments = true;

  /// Whether the role may book appointments.
  final bool canBookAppointments;

  /// Whether the role may approve or reject appointment requests.
  final bool canApproveAppointments;

  /// Whether the role may mark a patient as a no-show.
  final bool canMarkNoShow;

  /// Whether the role may manage the clinic, branches, departments, services
  /// and staff.
  final bool canManageClinic;

  /// Whether the role may view every appointment.
  final bool canViewAllAppointments;
}
