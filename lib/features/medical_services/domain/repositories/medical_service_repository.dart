import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';

/// Medical service persistence boundary. Success uses results; failures throw
/// [InstitutionException].
abstract interface class MedicalServiceRepository {
  /// Watches the medical services hosted by [branchId].
  /// Stream errors are emitted as [InstitutionException].
  Stream<DataResult<List<MedicalService>>> watchServices(String branchId);

  /// Watches records belonging to any of [branchIds], sorted by name.
  /// Empty lists emit an empty success; unsupported query sizes and provider
  /// failures are emitted as [InstitutionException] stream errors.
  Stream<DataResult<List<MedicalService>>> watchServicesOfBranches(
    List<String> branchIds,
  );

  /// Creates a medical service from [service]. Ignores [service.id] and returns
  /// the created record with its assigned identifier.
  /// Throws [InstitutionException] if creation fails.
  Future<DataResult<MedicalService>> createService(MedicalService service);

  /// Saves the changed values of [service].
  /// Throws [InstitutionException] if updating fails.
  Future<DataResult<MedicalService>> updateService(MedicalService service);
}
