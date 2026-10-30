/// Shares identity and display data across persisted institution entities.
/// Subclasses add the ownership and domain fields specific to each record.
abstract base class InstitutionRecord {
  /// Creates an institution record with its identifier and display name.
  const InstitutionRecord({required this.id, required this.name});

  /// The record's unique identifier.
  final String id;

  /// The record's display name.
  final String name;
}
