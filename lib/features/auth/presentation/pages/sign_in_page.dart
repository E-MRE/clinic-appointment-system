import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/enums/auth_form_kind.dart';
import 'package:clinic_appointment_system/features/auth/presentation/models/auth_form_values.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/auth_page.dart';

/// Email/password entry point for every account role.
final class SignInPage extends AuthPage<SignInCubit> {
  const SignInPage({required super.createCubit, super.key});

  @override
  AuthFormKind get kind => AuthFormKind.signIn;

  @override
  Future<void> submit(SignInCubit cubit, AuthFormValues values) {
    return cubit.signIn(
      AuthCredentials(email: values.email, password: values.password),
    );
  }
}
