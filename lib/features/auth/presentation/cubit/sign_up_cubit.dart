import 'package:clinic_appointment_system/features/auth/domain/models/auth_registration.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/register_patient_use_case.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/mixins/auth_validation_mixin.dart';

/// Validates patient registration input and registers the patient.
final class SignUpCubit extends AuthRequestCubit with AuthValidationMixin {
  SignUpCubit(this._registerPatient);

  final RegisterPatientUseCase _registerPatient;

  /// Registers with the sign-up password rules before running the use case.
  Future<void> signUp(AuthRegistration registration) {
    return executeRequest(
      validate: () => validateRegistration(registration),
      request: () => _registerPatient(registration),
    );
  }
}
