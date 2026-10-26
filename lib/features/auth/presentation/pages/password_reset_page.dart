import 'package:clinic_appointment_system/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/enums/auth_form_kind.dart';
import 'package:clinic_appointment_system/features/auth/presentation/models/auth_form_values.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/auth_page.dart';

/// Requests a reset email without revealing whether an account exists.
final class PasswordResetPage extends AuthPage<PasswordResetCubit> {
  const PasswordResetPage({required super.createCubit, super.key});

  @override
  AuthFormKind get kind => AuthFormKind.passwordReset;

  @override
  Future<void> submit(PasswordResetCubit cubit, AuthFormValues values) {
    return cubit.sendPasswordResetEmail(values.email);
  }
}
