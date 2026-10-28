import 'package:clinic_appointment_system/features/institution/domain/entities/institution_record.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';

/// An immutable physical location belonging to a clinic.
base class Branch extends InstitutionRecord {
  /// Creates a branch from already validated values.
  const Branch({
    required super.id,
    required super.name,
    required this.clinicId,
    required this.address,
    required this.workingHours,
  });

  /// The identifier of the clinic that owns this branch.
  final String clinicId;

  /// The branch's physical address.
  final String address;

  /// The weekly working hours for this branch.
  final WorkingHours workingHours;
}
