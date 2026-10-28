import 'package:clinic_appointment_system/features/auth/domain/models/auth_registration.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/enums/auth_form_kind.dart';
import 'package:clinic_appointment_system/features/auth/presentation/models/auth_form_values.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/auth_page.dart';

/// Patient-only account registration with a persisted name and confirmation.
final class SignUpPage extends AuthPage<SignUpCubit> {
  const SignUpPage({super.key});

  @override
  AuthFormKind get kind => AuthFormKind.signUp;

  @override
  Future<void> submit(SignUpCubit cubit, AuthFormValues values) {
    return cubit.signUp(
      AuthRegistration(
        fullName: values.fullName,
        email: values.email,
        password: values.password,
      ),
    );
  }
}
