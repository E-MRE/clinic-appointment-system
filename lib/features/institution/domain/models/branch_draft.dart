import 'package:clinic_appointment_system/features/institution/domain/models/institution_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';

/// Branch creation input before a repository assigns its identifier.
final class BranchDraft extends InstitutionDraft {
  /// Creates a branch draft with its clinic, name, address and working hours.
  const BranchDraft({
    required this.clinicId,
    required super.name,
    required this.address,
    required this.workingHours,
  });

  /// The identifier of the clinic that will own this branch.
  final String clinicId;

  /// The branch address to validate and save.
  final String address;

  /// The weekly working hours to save on this branch.
  final WorkingHours workingHours;

  @override
  BranchDraft trimmed() {
    return BranchDraft(
      clinicId: clinicId,
      name: name.trim(),
      address: address.trim(),
      workingHours: workingHours,
    );
  }
}
