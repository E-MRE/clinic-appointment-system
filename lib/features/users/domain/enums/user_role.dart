/// A user profile's role; its permissions come from `UserRolePermissions`.
enum UserRole {
  /// A patient who books appointments.
  patient,

  /// A doctor who approves appointments and marks no-shows.
  doctor,

  /// A technician who approves appointments.
  technician,

  /// An administrator who manages the clinic and sees every appointment.
  admin,
}
