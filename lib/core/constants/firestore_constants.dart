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

  /// Collection containing staff availability schedules.
  static const String staffAvailability = 'staffAvailability';

  /// Field storing recurring availability windows.
  static const String weekly = 'weekly';

  /// Field storing dated availability windows.
  static const String oneOff = 'oneOff';

  /// Field storing a calendar date.
  static const String date = 'date';

  /// Server timestamp recorded when a schedule is updated.
  static const String updatedAt = 'updatedAt';

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

  /// Field storing service fee in minor units.
  static const String feeMinorUnits = 'feeMinorUnits';

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

  /// Field storing a user profile's full name.
  static const String fullName = 'fullName';

  /// Field storing a user profile's email address.
  static const String email = 'email';

  /// Field storing a doctor's clinical specialty.
  static const String specialty = 'specialty';

  /// Field storing the medical services assigned to a staff profile.
  static const String serviceIds = 'serviceIds';

  /// Maximum number of values accepted by a Firestore whereIn query.
  static const int maxWhereInValues = 30;
}
