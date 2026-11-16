/// Provides the existing login emails linked into the generated scenario.
final class DemoAccountEmails {
  /// Uses the clinic owner's pre-created doctor and patient demo accounts.
  const DemoAccountEmails.demo()
    : doctor = 'servet@doktor.com',
      patient = 'remzi@pala.com';

  /// The login email of the existing doctor profile.
  final String doctor;

  /// The login email of the existing patient profile.
  final String patient;
}
