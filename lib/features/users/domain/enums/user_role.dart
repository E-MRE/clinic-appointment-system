/// A user profile's role and what the role may do.
enum UserRole {
  /// A patient who books appointments.
  patient(canBookAppointments: true),

  /// A doctor who approves appointments and marks no-shows.
  doctor(canApproveAppointments: true, canMarkNoShow: true),

  /// A technician who approves appointments.
  technician(canApproveAppointments: true),

  /// An administrator who manages the clinic and sees every appointment.
  admin(canManageClinic: true, canViewAllAppointments: true);

  const UserRole({
    this.canBookAppointments = false,
    this.canApproveAppointments = false,
    this.canMarkNoShow = false,
    this.canManageClinic = false,
    this.canViewAllAppointments = false,
  });

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
