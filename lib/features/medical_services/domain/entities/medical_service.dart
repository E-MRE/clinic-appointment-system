import 'package:clinic_appointment_system/features/institution/domain/entities/institution_record.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service_visitor.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';

/// Base class for all clinical and diagnostic medical services.
/// Subclasses provide kind-specific attributes, visitor dispatch and validation.
abstract base class MedicalService extends InstitutionRecord {
  /// Creates a medical service record.
  const MedicalService({
    required super.id,
    required super.name,
    required this.departmentId,
    required this.branchId,
    required this.duration,
    required this.fee,
  });

  /// Identifier of the department providing this service.
  final String departmentId;

  /// Identifier of the branch hosting this service.
  final String branchId;

  /// Standard duration allocated for this service.
  final ServiceDuration duration;

  /// Price charged for this service.
  final Money fee;

  /// The category of this medical service.
  /// Subclasses must return their specific [MedicalServiceKind].
  MedicalServiceKind get kind;

  /// Dispatches execution to the matching method on [visitor].
  /// Subclasses must call their corresponding visit method.
  R accept<R>(MedicalServiceVisitor<R> visitor);

  /// Creates a copy with surrounding whitespace trimmed from all text fields.
  /// Subclasses must return an instance of their own type with trimmed values.
  MedicalService trimmed();

  /// Creates a copy of this service with the updated [id].
  /// Subclasses must preserve all other properties unchanged.
  MedicalService withId(String id);

  /// Specific validation error for kind-specific properties, or null if valid.
  InstitutionErrorCode? get detailsError => null;
}
