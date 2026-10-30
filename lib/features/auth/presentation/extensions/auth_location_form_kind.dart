import 'package:clinic_appointment_system/features/auth/presentation/enums/auth_form_kind.dart';
import 'package:clinic_appointment_system/features/auth/presentation/extensions/auth_form_kind_config.dart';

/// Resolves the authentication screen a route location shows.
extension AuthLocationFormKind on String {
  /// The variant shown at this location, falling back to sign-in.
  AuthFormKind get authFormKind {
    return AuthFormKind.values.firstWhere(
      (kind) => kind.config.location == this,
      orElse: () => AuthFormKind.signIn,
    );
  }
}
