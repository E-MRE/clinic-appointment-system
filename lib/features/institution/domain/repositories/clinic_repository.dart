import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/clinic_draft.dart';

/// Clinic persistence boundary. Success uses results; failures throw
/// [InstitutionException].
abstract interface class ClinicRepository {
  /// Watches all clinics; stream errors are emitted as [InstitutionException].
  Stream<DataResult<List<Clinic>>> watchClinics();

  /// Creates a clinic from [draft].
  /// Throws [InstitutionException] if creation fails.
  Future<DataResult<Clinic>> createClinic(ClinicDraft draft);

  /// Saves the changed values of [clinic].
  /// Throws [InstitutionException] if updating fails.
  Future<DataResult<Clinic>> updateClinic(Clinic clinic);
}
