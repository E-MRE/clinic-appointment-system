import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/core/usecases/use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/mixins/institution_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/mixins/medical_service_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/repositories/medical_service_repository.dart';

/// Validates and saves changes to an existing medical service.
final class UpdateMedicalServiceUseCase
    with InstitutionInputValidationMixin, MedicalServiceInputValidationMixin
    implements UseCase<DataResult<MedicalService>, MedicalService> {
  /// Injects the medical service persistence boundary.
  const UpdateMedicalServiceUseCase(this._repository);

  final MedicalServiceRepository _repository;

  /// Saves [service] with trimmed text fields after validating domain constraints.
  /// Throws [InstitutionException] if validation fails or persistence fails.
  @override
  Future<DataResult<MedicalService>> call(MedicalService service) async {
    final trimmed = service.trimmed();
    ensureValid(serviceError(trimmed));
    return _repository.updateService(trimmed);
  }
}
