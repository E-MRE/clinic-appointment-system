import 'package:clinic_appointment_system/features/institution/domain/entities/institution_record.dart';

/// An immutable clinic that owns one or more branches.
base class Clinic extends InstitutionRecord {
  /// Creates a clinic from already validated values.
  const Clinic({required super.id, required super.name});
}
