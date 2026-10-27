import 'package:clinic_appointment_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/watch_session_use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/watch_user_profile_use_case.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/users/domain/repositories/user_repository.dart';

/// Builds an [AuthCubit] whose use cases run against the given test doubles.
AuthCubit createAuthCubit(AuthRepository repository, UserRepository users) {
  return AuthCubit(
    WatchSessionUseCase(repository),
    WatchUserProfileUseCase(users),
    SignOutUseCase(repository),
  );
}
