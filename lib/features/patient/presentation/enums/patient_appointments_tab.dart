/// Tabs filtering the patient's appointment table.
enum PatientAppointmentsTab {
  /// Upcoming appointments first, then past ones.
  all,

  /// Pending or approved appointments that have not started.
  upcoming,

  /// Every appointment that is not upcoming.
  past,
}
