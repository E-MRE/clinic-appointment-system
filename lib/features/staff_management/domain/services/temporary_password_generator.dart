import 'package:clinic_appointment_system/features/auth/domain/mixins/auth_input_validation_mixin.dart';

/// Temporary password boundary; implementations must generate sign-up input.
abstract interface class TemporaryPasswordGenerator {
  /// Implementations must return a value accepted by
  /// [AuthInputValidationMixin.passwordError] with `isSignUp: true` every time.
  String generate();
}
