/// Firestore collection and document field names.
abstract final class FirestoreConstants {
  /// Collection containing clinics.
  static const String clinics = 'clinics';

  /// Collection containing clinic branches.
  static const String branches = 'branches';

  /// Collection containing branch departments.
  static const String departments = 'departments';

  /// Collection containing medical services.
  static const String services = 'services';

  /// Collection containing user profiles.
  static const String users = 'users';

  /// Field storing the clinic that owns a branch.
  static const String clinicId = 'clinicId';

  /// Field storing the branch that owns a department.
  static const String branchId = 'branchId';

  /// Field storing the department that owns a medical service.
  static const String departmentId = 'departmentId';

  /// Field storing an institution record's display name.
  static const String name = 'name';

  /// Field storing the category of medical service.
  static const String kind = 'kind';

  /// Field storing service duration in minutes.
  static const String durationMinutes = 'durationMinutes';

  /// Field storing service fee in kurus.
  static const String feeKurus = 'feeKurus';

  /// Field storing imaging modality for radiology services.
  static const String modality = 'modality';

  /// Field storing preparation instructions for radiology procedures.
  static const String preparationNote = 'preparationNote';

  /// Field indicating whether fasting is required before a laboratory test.
  static const String requiresFasting = 'requiresFasting';

  /// Field storing fasting hours range for a laboratory test.
  static const String fastingHours = 'fastingHours';

  /// Field storing the minimum value in a numeric range.
  static const String minimum = 'min';

  /// Field storing the maximum value in a numeric range.
  static const String maximum = 'max';

  /// Field storing laboratory test result turnaround timeframe.
  static const String resultTime = 'resultTime';

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
