import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';

/// Shares institution name validation between use cases.
mixin InstitutionInputValidationMixin {
  /// Requires a name with at least one non-whitespace character.
  InstitutionErrorCode? nameError(String name) {
    return name.trim().isEmpty ? InstitutionErrorCode.nameRequired : null;
  }

  /// Requires a branch address with at least one non-whitespace character.
  InstitutionErrorCode? addressError(String address) {
    return address.trim().isEmpty ? InstitutionErrorCode.addressRequired : null;
  }

  /// Throws [InstitutionException] when [error] represents a failed check.
  void ensureValid(InstitutionErrorCode? error) {
    if (error != null) throw InstitutionException(error);
  }
}
