import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/core/usecases/use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/mixins/institution_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/clinic_repository.dart';

/// Validates and updates a clinic.
final class UpdateClinicUseCase
    with InstitutionInputValidationMixin
    implements UseCase<DataResult<Clinic>, Clinic> {
  /// Injects the clinic persistence boundary.
  const UpdateClinicUseCase(this._repository);

  final ClinicRepository _repository;

  /// Updates the clinic with a trimmed name and returns the repository result.
  /// Throws [InstitutionException] if the name is blank or updating fails.
  @override
  Future<DataResult<Clinic>> call(Clinic clinic) async {
    ensureValid(nameError(clinic.name));
    final updatedClinic = Clinic(id: clinic.id, name: clinic.name.trim());
    return _repository.updateClinic(updatedClinic);
  }
}
