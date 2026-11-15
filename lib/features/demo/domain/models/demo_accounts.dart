/// Existing authenticated accounts that the generated scenario must reuse.
final class DemoAccounts {
  /// Supplies profile identity for the linked doctor and patient accounts.
  const DemoAccounts({
    required this.doctorUid,
    required this.doctorFullName,
    required this.doctorEmail,
    required this.patientUid,
    required this.patientFullName,
    required this.patientEmail,
  });

  /// The authentication uid for the doctor profile in the scenario.
  final String doctorUid;

  /// The existing doctor's profile name.
  final String doctorFullName;

  /// The existing doctor's account email.
  final String doctorEmail;

  /// The authentication uid for the patient profile in the scenario.
  final String patientUid;

  /// The existing patient's profile name.
  final String patientFullName;

  /// The existing patient's account email.
  final String patientEmail;
}
