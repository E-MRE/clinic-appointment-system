/// Firestore collection and metadata field names.
abstract final class FirestoreConstants {
  /// Collection containing user profiles.
  static const users = 'users';

  /// Field storing the role a profile document belongs to.
  static const role = 'role';

  /// Server timestamp recorded when a profile is created.
  static const createdAt = 'createdAt';
}
