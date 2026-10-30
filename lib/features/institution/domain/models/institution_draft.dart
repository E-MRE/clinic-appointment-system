/// Creation input shared by clinic, branch and department drafts before a
/// repository assigns an identifier.
///
/// Subclasses add the owner identifier and the fields of their entity, and
/// implement [trimmed] so use cases save normalized text.
abstract base class InstitutionDraft {
  /// Creates a draft with its raw [name].
  const InstitutionDraft({required this.name});

  /// The name to validate and save.
  final String name;

  /// Returns a copy with surrounding whitespace removed from every text field.
  InstitutionDraft trimmed();
}
