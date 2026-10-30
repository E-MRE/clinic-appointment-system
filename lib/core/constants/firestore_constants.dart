/// Firestore collection and document field names.
abstract final class FirestoreConstants {
  /// Collection containing clinics.
  static const String clinics = 'clinics';

  /// Collection containing clinic branches.
  static const String branches = 'branches';

  /// Collection containing branch departments.
  static const String departments = 'departments';

  /// Collection containing user profiles.
  static const String users = 'users';

  /// Field storing the clinic that owns a branch.
  static const String clinicId = 'clinicId';

  /// Field storing the branch that owns a department.
  static const String branchId = 'branchId';

  /// Field storing an institution record's display name.
  static const String name = 'name';

  /// Field storing a branch's physical address.
  static const String address = 'address';

  /// Field storing a branch's weekly working hours.
  static const String workingHours = 'workingHours';

  /// Field storing the start of a working time range.
  static const String start = 'start';

  /// Field storing the end of a working time range.
  static const String end = 'end';

  /// Field storing the role a profile document belongs to.
  static const String role = 'role';

  /// Server timestamp recorded when a profile is created.
  static const String createdAt = 'createdAt';
}
