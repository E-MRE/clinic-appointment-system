import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/core/usecases/use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/mixins/institution_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/clinic_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/clinic_repository.dart';

/// Validates and creates a clinic.
final class CreateClinicUseCase
    with InstitutionInputValidationMixin
    implements UseCase<DataResult<Clinic>, ClinicDraft> {
  /// Injects the clinic persistence boundary.
  const CreateClinicUseCase(this._repository);

  final ClinicRepository _repository;

  /// Creates the clinic with a trimmed name and returns the repository result.
  /// Throws [InstitutionException] if the name is blank or creation fails.
  @override
  Future<DataResult<Clinic>> call(ClinicDraft draft) async {
    ensureValid(nameError(draft.name));
    return _repository.createClinic(ClinicDraft(name: draft.name.trim()));
  }
}
