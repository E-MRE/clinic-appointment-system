import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';

/// Branch creation input before a repository assigns its identifier.
final class BranchDraft {
  /// Creates a branch draft with its clinic, name, address and working hours.
  const BranchDraft({
    required this.clinicId,
    required this.name,
    required this.address,
    required this.workingHours,
  });

  /// The identifier of the clinic that will own this branch.
  final String clinicId;

  /// The branch name to validate and save.
  final String name;

  /// The branch address to validate and save.
  final String address;

  /// The weekly working hours to save on this branch.
  final WorkingHours workingHours;
}
