import 'package:clinic_appointment_system/features/auth/domain/models/auth_registration.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/register_patient_use_case.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_cubit.dart';

/// Registers a patient through the registration use case.
final class SignUpCubit extends AuthRequestCubit {
  SignUpCubit(this._registerPatient);

  final RegisterPatientUseCase _registerPatient;

  /// Registers the patient; the use case applies the sign-up input rules.
  Future<void> signUp(AuthRegistration registration) {
    return executeRequest(() => _registerPatient(registration));
  }
}
