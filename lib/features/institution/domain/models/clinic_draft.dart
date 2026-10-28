/// Clinic creation input before a repository assigns its identifier.
final class ClinicDraft {
  /// Creates a clinic draft with its raw name.
  const ClinicDraft({required this.name});

  /// The clinic name to validate and save.
  final String name;
}
