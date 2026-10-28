/// Firestore collection and document field names.
abstract final class FirestoreConstants {
  /// Collection containing clinics.
  static const clinics = 'clinics';

  /// Collection containing clinic branches.
  static const branches = 'branches';

  /// Collection containing branch departments.
  static const departments = 'departments';

  /// Collection containing user profiles.
  static const users = 'users';

  /// Field storing the clinic that owns a branch.
  static const clinicId = 'clinicId';

  /// Field storing the branch that owns a department.
  static const branchId = 'branchId';

  /// Field storing an institution record's display name.
  static const name = 'name';

  /// Field storing a branch's physical address.
  static const address = 'address';

  /// Field storing a branch's weekly working hours.
  static const workingHours = 'workingHours';

  /// Field storing the start of a working time range.
  static const start = 'start';

  /// Field storing the end of a working time range.
  static const end = 'end';

  /// Field storing the role a profile document belongs to.
  static const role = 'role';

  /// Server timestamp recorded when a profile is created.
  static const createdAt = 'createdAt';
}
